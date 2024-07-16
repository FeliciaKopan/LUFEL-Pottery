//
//  CartTableViewCell.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 28.06.2024.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    struct Identifier {
        let imageUrl: URL?
        let title: String
        let price: Double
        let description: String?
        let quantity: Int
    }

    // MARK: - Views

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var decrementView: UIView!
    @IBOutlet weak var incrementView: UIView!
    @IBOutlet weak var separatorView: UIView!
    
    // MARK: - Properties

    private var currentProduct: Product?
    @Injected(\.cartProvider) var cartProvider: CartProviding

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupDecrementQuantity()
        setupIncrementQuantity()
    }

    override func prepareForReuse() {
        productImageView.image = nil
        nameLabel.text = ""
        priceLabel.text = ""
        quantityLabel.text = ""
        currentProduct = nil
        separatorView.isHidden = false
    }

    // MARK: - Actions

    @objc private func decrementQuantity() {
        if var product = currentProduct, let quantity = product.quantity {
            product.quantity = quantity - 1
            if quantity <= 0 {
                cartProvider.removeProductFromCart(product)
            } else {
                cartProvider.updateProductQuantity(product)
            }
        }
    }

    @objc private func incrementQuantity() {
        if var product = currentProduct, let quantity = product.quantity {
            product.quantity = quantity + 1
            cartProvider.updateProductQuantity(product)
        }
    }

    // MARK: - Public methods

    func configure(with identifier: Identifier, product: Product) {
        if let url = identifier.imageUrl {
            productImageView.load(url: url)
        }
        nameLabel.text = identifier.title
        priceLabel.text = "\(identifier.price) lei"
        quantityLabel.text = "\(identifier.quantity)"
        currentProduct = product
    }

    func setSeparatorVisibility(isHidden: Bool) {
        separatorView.isHidden = isHidden
    }

    // MARK: - Private methods

    private func setupDecrementQuantity() {
        let decrementQuantityTapGesture = UITapGestureRecognizer(target: self, action: #selector(decrementQuantity))
        decrementView.addGestureRecognizer(decrementQuantityTapGesture)
    }

    private func setupIncrementQuantity() {
        let incrementQuantityTapGesture = UITapGestureRecognizer(target: self, action: #selector(incrementQuantity))
        incrementView.addGestureRecognizer(incrementQuantityTapGesture)
    }
}
