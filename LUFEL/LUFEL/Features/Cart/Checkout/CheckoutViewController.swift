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
    @IBOutlet weak var addressTextField: CustomPlaceholderTextView!
    @IBOutlet weak var paymentMethodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var placeOrderButton: UIButton!
    
    // MARK: - Properties

    private var cartProducts: [Product] = []
    private var cancellables = Set<AnyCancellable>()

    @Injected(\.cartProvider) var cartProvider: CartProviding

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        loadCartProducts()
    }

    @IBAction func goBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func placeTheOrder(_ sender: Any) {
        
    }
    
    // MARK: - Private methods

    private func setupTableView() {
        tableView.backgroundColor = UIColor.black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(CheckoutTableViewCell.self)
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }

    private func loadCartProducts() {
        let cart = cartProvider.getCartProducts()
        cartProducts = cart.products
        totalPriceLabel.text = "Total Price: \(cart.totalPrice) lei"
        tableView.reloadData()
    }

    private func removeProduct(at indexPath: IndexPath) {
        let product = cartProducts[indexPath.row]
        cartProvider.removeProductFromCart(product)
        cartProducts.remove(at: indexPath.row)
        loadCartProducts()
    }
}

extension CheckoutViewController: UITableViewDelegate {

}

extension CheckoutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(of: CheckoutTableViewCell.self, for: indexPath) as? CheckoutTableViewCell else {
            return UITableViewCell()
        }
        let product = cartProducts[indexPath.row]
        if let imageUrl = product.imageUrl,
           let url = URL(string: imageUrl),
           let quantity = product.quantity {
            cell.configure(with: .init(imageUrl: url,
                                       title: product.title,
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
