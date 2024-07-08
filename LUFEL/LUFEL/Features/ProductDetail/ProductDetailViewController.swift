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

    private var currentProduct: Product

    @Injected(\.favoriteProvider) var favoriteProvider: FavoriteProviding
    @Injected(\.cartProvider) var cartProvider: CartProviding

    // MARK: - Init

    init(product: Product) {
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
        setupCartView()
        setupWishListView()
    }

    // MARK: - Actions

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true)
    }

    @objc private func addToCartTapped() {
        cartProvider.addProductToCart(currentProduct)
    }

    @objc private func favoriteTapped() {
        favoriteProvider.addFavorite(currentProduct)
    }

    // MARK: - Private methods

    private func setupCartView() {
        let addToCartTapGesture = UITapGestureRecognizer(target: self, action: #selector(addToCartTapped))
        cartView.addGestureRecognizer(addToCartTapGesture)
    }

    private func setupWishListView() {
        let favoriteTapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteTapped))
        wishListView.addGestureRecognizer(favoriteTapGesture)
    }

    private func setupView() {
        if let imageUrl = currentProduct.imageUrl, let url = URL(string: imageUrl) {
            imageView.load(url: url)
        }
        nameLabel.text = currentProduct.title
        priceLabel.text = "\(currentProduct.price) lei"
        detailsLabel.text = currentProduct.description
    }
}
