//
//  CheckoutViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 14.06.2024.
//

import UIKit
import Combine
import Stripe

class CheckoutViewController: UIViewController {

    // MARK: - Views

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var paymentMethodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var deliveryMethodLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    // MARK: - Properties

    private var newOrder: NewOrder
    private var cancellables = Set<AnyCancellable>()
    private lazy var dataSource = makeDataSource()

    @Injected(\.cartProvider) var cartProvider: CartProviding

    // MARK: - Initializer

    init(newOrder: NewOrder) {
        self.newOrder = newOrder
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = viewFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        loadCartProducts()
        setupSegmentControl()
    }

    @IBAction func finalizeOrder(_ sender: Any) {
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

    // MARK: - Private methods

    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(CheckoutTableViewCell.self)
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }

    private func loadCartProducts() {
        totalPriceLabel.text = "Total Price: \(newOrder.totalPrice) lei"
        deliveryMethodLabel.text = "Metoda de livrare: \(newOrder.shippingMethod?.rawValue.capitalized ?? "")"
        if let addressDetails = newOrder.addressDetails {
            addressLabel.text = "\(addressDetails.address), \(addressDetails.locality), \(addressDetails.county)"
        }
        applySnapshot()
    }

    private func removeProduct(_ product: Product) {
        if let index = newOrder.products.firstIndex(where: { $0.id == product.id }) {
            newOrder.products.remove(at: index)
            cartProvider.removeProductFromCart(product)
            totalPriceLabel.text = "Total Price: \(newOrder.totalPrice) lei"
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

    private func setupSegmentControl() {
        paymentMethodSegmentedControl.addTarget(self, action: #selector(paymentMethodChanged), for: .valueChanged)
    }

    private func makeDataSource() -> UITableViewDiffableDataSource<SingleSection, Product> {
        return UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, product in
            guard let cell = tableView.dequeueReusableCell(of: CheckoutTableViewCell.self, for: indexPath) as? CheckoutTableViewCell else {
                return UITableViewCell()
            }

            if let imageUrl = product.imageUrl,
               let url = URL(string: imageUrl),
               let quantity = product.quantity {
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
        snapshot.appendItems(newOrder.products)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    @objc private func paymentMethodChanged() {
        if paymentMethodSegmentedControl.selectedSegmentIndex == 1 {
            let addCardViewController = STPAddCardViewController()
            addCardViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: addCardViewController)
            present(navigationController, animated: true, completion: nil)
        }
    }

    private func simulatePaymentConfirmation(with paymentMethod: STPPaymentMethod) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("PaymentMethod ID: \(paymentMethod.stripeId)")
            self.showAlert(title: "Payment Successful", message: "Your payment was successful.")
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension CheckoutViewController: UITableViewDelegate {

}

extension CheckoutViewController: STPAddCardViewControllerDelegate {
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true, completion: nil)
    }

    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
        simulatePaymentConfirmation(with: paymentMethod)
        completion(nil)
        dismiss(animated: true, completion: nil)
    }
}
