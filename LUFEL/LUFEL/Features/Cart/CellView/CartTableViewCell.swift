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
        let price: String
        let description: String?
        let quantity: Int
    }

    // MARK: - Views

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var incrementButton: UIButton!

    // MARK: - Properties

    private var currentProduct: Product?
    @Injected(\.cartProvider) var cartProvider: CartProviding

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

    // MARK: - Actions

    @IBAction func deleteProduct(_ sender: Any) {
        if let product = currentProduct {
            cartProvider.removeProductFromCart(product)
        }
    }
    
    @IBAction func decrementQuantity(_ sender: Any) {
        if var product = currentProduct, let quantity = product.quantity {
            product.quantity = quantity - 1
            if product.quantity! <= 0 {
                cartProvider.removeProductFromCart(product)
            } else {
                cartProvider.updateProductQuantity(product)
            }
        }
    }
    
    @IBAction func incrementQuantity(_ sender: Any) {
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
        priceLabel.text = identifier.price
        quantityLabel.text = "\(identifier.quantity)"
        currentProduct = product
    }

}
