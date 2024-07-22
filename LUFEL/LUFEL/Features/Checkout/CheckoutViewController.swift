//
//  CheckoutViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 14.06.2024.
//

import UIKit
import Combine

class CheckoutViewController: UIViewController {

    // MARK: - Views

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var paymentMethodSegmentedControl: UISegmentedControl!
    
    // MARK: - Properties

    private var newOrder: NewOrder?
    private var cancellables = Set<AnyCancellable>()
    private lazy var dataSource = makeDataSource()

    @Injected(\.cartProvider) var cartProvider: CartProviding

    // MARK: - Lifecycle

    override func loadView() {
        view = viewFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        loadCartProducts()
    }

    @IBAction func goBackButton(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func finalizeOrder(_ sender: Any) {
        guard var newOrder = newOrder else { return }
        switch paymentMethodSegmentedControl.selectedSegmentIndex {
        case 0:
            newOrder.paymentMethod = .cashOnDelivery
        case 1:
            newOrder.paymentMethod = .creditCard
        default:
            break
        }

        do {
            let jsonData = try JSONEncoder().encode(newOrder)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }

            resetOrder()

            let alert = UIAlertController(title: "Order Saved", message: "Your order is in process.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } catch {
            print("Failed to encode new order: \(error)")
        }
    }

    // MARK: - Public methods

    func setOrder(_ order: NewOrder?) {
        self.newOrder = order
    }

    // MARK: - Private methods

    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(CheckoutTableViewCell.self)
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }

    private func calculateTotalPrice() -> Double {
        return newOrder?.products.reduce(0) { $0 + $1.price * Double($1.quantity ?? 1) } ?? 0.0
    }

    private func loadCartProducts() {
        if newOrder != nil {
            totalPriceLabel.text = "Total Price: \(calculateTotalPrice()) lei"
            applySnapshot()
        }
    }

    private func removeProduct(_ product: Product) {
        guard var newOrder = newOrder else { return }
        if let index = newOrder.products.firstIndex(where: { $0.id == product.id }) {
            newOrder.products.remove(at: index)
            cartProvider.removeProductFromCart(product)
            self.newOrder = newOrder
            totalPriceLabel.text = "Total Price: \(calculateTotalPrice()) lei"
            applySnapshot()

            if newOrder.products.isEmpty {
                dismiss(animated: true)
            }
        }
    }

    private func resetOrder() {
        newOrder = NewOrder(products: [])
        cartProvider.clearCart()
    }

    private func makeDataSource() -> UITableViewDiffableDataSource<SingleSection, Product> {
        return UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, product in
            guard let cell = tableView.dequeueReusableCell(of: CheckoutTableViewCell.self, for: indexPath) as? CheckoutTableViewCell else {
                return UITableViewCell()
            }

            if let imageUrl = product.imageUrl,
               let url = URL(string: imageUrl),
               let quantity = product.quantity{
                let identifier = CheckoutTableViewCell.Identifier(
                    imageUrl: url,
                    title: product.title,
                    quantity: quantity
                )
                cell.configure(with: identifier)

                cell.removeProductPublisher
                    .sink { [weak self] _ in
                        self?.removeProduct(product)
                    }
                    .store(in: &self.cancellables)
            }
            return cell
        }
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SingleSection, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(newOrder?.products ?? [])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension CheckoutViewController: UITableViewDelegate {

}
