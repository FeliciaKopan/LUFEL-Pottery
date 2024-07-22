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

    @Injected(\.cartProvider) var cartProvider: CartProviding

    // MARK: - Lifecycle

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
        tableView.dataSource = self
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
            tableView.reloadData()
        }
    }

    private func removeProduct(at indexPath: IndexPath) {
        guard var newOrder = newOrder else { return }
        let product = newOrder.products[indexPath.row]
        newOrder.products.remove(at: indexPath.row)
        cartProvider.removeProductFromCart(product)
        tableView.reloadData()
//        totalPriceLabel.text = "Total Price: \(calculateTotalPrice()) lei"
    }

    private func resetOrder() {
        newOrder = NewOrder(products: [])
        cartProvider.clearCart()
    }
}

extension CheckoutViewController: UITableViewDelegate {

}

extension CheckoutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newOrder?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(of: CheckoutTableViewCell.self, for: indexPath) as? CheckoutTableViewCell else {
            return UITableViewCell()
        }
        let product = newOrder?.products[indexPath.row]
        if let imageUrl = product?.imageUrl,
           let url = URL(string: imageUrl),
           let quantity = product?.quantity {
            cell.configure(with: .init(imageUrl: url,
                                       title: product?.title ?? "",
                                       quantity: quantity
                                      ))
        }

        cell.removeProductPublisher
            .sink { [weak self] in
                self?.removeProduct(at: indexPath)
            }
            .store(in: &cancellables)

        return cell
    }
}
