//
//  WishListViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 14.06.2024.
//

import UIKit

class WishListViewController: UIViewController {

    // MARK: - Views

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties

    private var wishListProducts: [Product] = []

    @Injected(\.favoriteProvider) var favoriteProvider: FavoriteProviding

    // MARK: - Lifecycle

    override func loadView() {
        view = viewFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        wishListProducts = favoriteProvider.getFavorites()
        tableView.reloadData()
        (parent as? MainTabViewController)?.update(color: .black)
    }

    // MARK: - Private methods

    private func setupTableView() {
        tableView.backgroundColor = UIColor.black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(WishListTableViewCell.self)
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }

}
extension WishListViewController: UITableViewDelegate {

}

extension WishListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishListProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(of: WishListTableViewCell.self, for: indexPath) as? WishListTableViewCell else {
            return UITableViewCell()
        }

        let product = wishListProducts[indexPath.row]

        if let imageUrl = product.imageUrl,
           let url = URL(string: imageUrl) {
            cell.configure(with: .init(imageUrl: url,
                                       title: product.title,
                                       price: product.price,
                                       description: "descriere"
                                      ))
        }
        return cell
    }
}
