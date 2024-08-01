//
//  ProductsListViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 18.06.2024.
//

import UIKit
import Combine

class ProductsListViewController: UIViewController {

    // MARK: - Views

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterButtonView: UIView!
    @IBOutlet weak var filterView: FilterProductsView!
    
    // MARK: - Properties

    private var sections: [ProductCategory] = []
    private var filteredSections: [ProductCategory] = []
    private var selectedFilters: [String] = []
    private var isFilteringByType = false
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle

    override func loadView() {
        view = viewFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupFilterView()
        loadProducts()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (parent as? MainTabViewController)?.update(color: .black)
    }

    // MARK: - Private methods

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCell(type: ProductCollectionViewCell.self)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
    }

    private func setupFilterView() {
        filterButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleFilterView)))
        filterView.isHidden = true
    }

    private func loadProducts() {
        guard let path = Bundle.main.path(forResource: "Products", ofType: "json") else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decodedResponse = try JSONDecoder().decode(CategoryResponse.self, from: data)
            sections = decodedResponse.sections
            collectionView.reloadData()
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }

    @objc private func toggleFilterView() {
        filterView.isHidden.toggle()
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.dismiss(animated: true)
        }
    }
}

// MARK: - Extensions

extension ProductsListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueCell(withType: ProductCollectionViewCell.self, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        let product = sections[indexPath.section].products[indexPath.item]
        if let imageUrl = product.imageUrl,
           let url = URL(string: imageUrl) {
            cell.configure(with: .init(imageUrl: url, title: product.title, price: product.price), product: product)
        }

        cell.addToCartPublisher
            .sink { [weak self] product in
                self?.showAlert(message: L10n.Cart.addToCart)
            }
            .store(in: &cancellables)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 30, height: ((UIScreen.main.bounds.width / 2) - 30) * 1.4 + 80)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
        headerView.subviews.forEach { $0.removeFromSuperview() }
        let label = UILabel(frame: CGRect(x: 24, y: 0, width: collectionView.frame.width, height: 40))
        label.text = sections[indexPath.section].title
        label.textAlignment = .left
        label.textColor = .black
        headerView.addSubview(label)
        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = sections[indexPath.section].products[indexPath.row]
        let viewController = ProductDetailViewController(product: product)
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: true)
    }
}

extension ProductsListViewController: UICollectionViewDelegate {

}

extension ProductsListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
}
