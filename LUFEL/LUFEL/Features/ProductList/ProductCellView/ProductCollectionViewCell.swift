//
//  ProductCollectionViewCell.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 21.06.2024.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    struct Identifier {
        let imageUrl: URL?
        let title: String
        let price: Double
    }

    // MARK: - Views

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToCartView: UIView!
    @IBOutlet weak var favoriteView: UIView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var cartImageView: UIImageView!

    // MARK: - Properties

    private var currentProduct: Product?
    private var isFavorite: Bool = false

    @Injected(\.favoriteProvider) var favoriteProvider: FavoriteProviding
    @Injected(\.cartProvider) var cartProvider: CartProviding

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        addToCart()
        addToWishList()
    }

    // MARK: - Public methods

    func configure(with identifier: Identifier, product: Product) {
        if let url = identifier.imageUrl {
            imageView.load(url: url)
        }
        titleLabel.text = identifier.title
        priceLabel.text = "\(identifier.price) lei"
        currentProduct = product
        isFavorite = favoriteProvider.isFavorite(product)
        updateFavoriteIcon()
    }

    // MARK: - Private methods

    private func addToCart() {
        let addToCartTapGesture = UITapGestureRecognizer(target: self, action: #selector(addToCartTapped))
        addToCartView.addGestureRecognizer(addToCartTapGesture)
    }

    private func addToWishList() {
        let favoriteTapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteTapped))
        favoriteView.addGestureRecognizer(favoriteTapGesture)
    }

    private func updateFavoriteIcon() {
        favoriteImageView.tintColor = isFavorite ? .red : .black
    }

    @objc private func addToCartTapped() {
        if let product = currentProduct {
            cartProvider.addProductToCart(product)
        }
    }

    @objc private func favoriteTapped() {
        guard let product = currentProduct else { return }
        if isFavorite {
            favoriteProvider.removeFavorite(product)
            isFavorite = false
        } else {
            favoriteProvider.addFavorite(product)
            isFavorite = true
        }
        updateFavoriteIcon()
    }
}
