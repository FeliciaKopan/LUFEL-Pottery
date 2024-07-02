//
//  ProductDetailViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 02.07.2024.
//

import UIKit

class ProductDetailViewController: UIViewController {

    // MARK: - Views

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var wishListView: UIView!
    
    // MARK: - Properties

    private let productImageUrl: String?
    private let productTitle: String
    private let productPrice: Double
    private let productDetails: String
    private var currentProduct: Product?

    @Injected(\.favoriteProvider) var favoriteProvider: FavoriteProviding
    @Injected(\.cartProvider) var cartProvider: CartProviding

    // MARK: - Init

    init(product: Product) {
        self.productImageUrl = product.imageUrl
        self.productTitle = product.title
        self.productPrice = product.price
        self.productDetails = product.description ?? ""
        self.currentProduct = product
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        addToCart()
        addToWishList()
    }

    // MARK: - Actions

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true)
    }

    @objc private func addToCartTapped() {
        if let product = currentProduct {
            cartProvider.addProductToCart(product)
        }
    }

    @objc private func favoriteTapped() {
        if let product = currentProduct {
            favoriteProvider.addFavorite(product)
        }
    }

    // MARK: - Private methods

    private func addToCart() {
        let addToCartTapGesture = UITapGestureRecognizer(target: self, action: #selector(addToCartTapped))
        cartView.addGestureRecognizer(addToCartTapGesture)
    }

    private func addToWishList() {
        let favoriteTapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteTapped))
        wishListView.addGestureRecognizer(favoriteTapGesture)
    }

    private func setupView() {
        if let imageUrl = productImageUrl, let url = URL(string: imageUrl) {
            imageView.load(url: url)
        }
        nameLabel.text = productTitle
        priceLabel.text = "\(productPrice) lei"
        detailsLabel.text = productDetails
    }
}
