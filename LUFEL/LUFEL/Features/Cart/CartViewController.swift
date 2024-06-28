//
//  CartViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 14.06.2024.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var productsPriceLabel: UILabel!
    @IBOutlet weak var transportPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var placeTheOrderButton: UIButton!
    
    // MARK: - Properties

    private var cartProducts: [Product] = []

    @Injected(\.cartProvider) var cartProvider: CartProviding

    // MARK: - Lifecycle

    override func loadView() {
        view = viewFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        observeCartProducts()
        loadCartProducts()
        updatePlaceOrderButtonState()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCartProducts()
        (parent as? MainTabViewController)?.update(color: .black)
    }

    // MARK: - Actions

    @IBAction func placeTheOrder(_ sender: Any) {
        let viewController = CheckoutViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }

    // MARK: - Private methods

    private func setupTableView() {
        tableView.backgroundColor = UIColor.black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(CartTableViewCell.self)
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }

    private func observeCartProducts() {
        NotificationCenter.default.addObserver(self, selector: #selector(cartUpdated), name: .cartUpdated, object: nil)
    }

    @objc private func cartUpdated() {
        loadCartProducts()
        updatePlaceOrderButtonState()
    }

    private func loadCartProducts() {
        let cart = cartProvider.getCartProducts()
        cartProducts = cart.products
        totalPriceLabel.text = "Total Price: \(cart.totalPrice) lei"
        tableView.reloadData()
    }

    private func updatePlaceOrderButtonState() {
        placeTheOrderButton.isEnabled = !cartProducts.isEmpty
    }
}

extension CartViewController: UITableViewDelegate {

}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(of: CartTableViewCell.self, for: indexPath) as? CartTableViewCell else {
            return UITableViewCell()
        }

        let product = cartProducts[indexPath.row]

        if let imageUrl = product.imageUrl,
           let url = URL(string: imageUrl),
           let quantity = product.quantity {
            cell.configure(with: .init(imageUrl: url,
                                       title: product.title,
                                       price: product.price,
                                       description: "product.description",
                                       quantity: quantity), 
                           product: product)
        }
        return cell
    }
}
