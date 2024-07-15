//
//  CartViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 14.06.2024.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var placeTheOrderButton: UIButton!
    @IBOutlet weak var emptyView: EmptyStateView!
    
    // MARK: - Properties

    private var cartProducts: [Product] = []
    private lazy var dataSource = makeDataSource()

    @Injected(\.cartProvider) var cartProvider: CartProviding

    // MARK: - Lifecycle

    override func loadView() {
        view = viewFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupEmptyView()
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
        tableView.backgroundColor = .appBackground
        tableView.delegate = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(CartTableViewCell.self)
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
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
        applySnapshot(animatingDifferences: true)
    }

    private func updatePlaceOrderButtonState() {
        placeTheOrderButton.isEnabled = !cartProducts.isEmpty
        placeTheOrderButton.isHidden = cartProducts.isEmpty ? true : false
        totalPriceLabel.isHidden = cartProducts.isEmpty ? true : false
        tableView.isHidden = cartProducts.isEmpty ? true : false
        emptyView.isHidden = cartProducts.isEmpty ? false : true
    }

    private func makeDataSource() -> UITableViewDiffableDataSource<SingleSection, Product> {
        return UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, product in
            guard let cell = tableView.dequeueReusableCell(of: CartTableViewCell.self, for: indexPath) as? CartTableViewCell else {
                return UITableViewCell()
            }

            if let imageUrl = product.imageUrl,
               let url = URL(string: imageUrl),
               let quantity = product.quantity {
                let identifier = CartTableViewCell.Identifier(
                    imageUrl: url,
                    title: product.title,
                    price: product.price,
                    description: product.description,
                    quantity: quantity
                )
                cell.configure(with: identifier, product: product)
            }
            return cell
        }
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<SingleSection, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(cartProducts)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func setupEmptyView() {
        emptyView.configure(title: L10n.Cart.emptyTitle)
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? CartTableViewCell {
            let isLastCell = indexPath.row == cartProducts.count - 1
            cell.setSeparatorVisibility(isHidden: isLastCell)
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self]  _, _, _ in
            guard let self = self else { return }
            let product = self.cartProducts[indexPath.row]
            self.cartProvider.removeProductFromCart(product)
            self.loadCartProducts()
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
