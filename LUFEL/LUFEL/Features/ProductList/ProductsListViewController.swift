//
//  ProductsListViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 18.06.2024.
//

import UIKit

class ProductsListViewController: UIViewController {

    // MARK: - Views

    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Properties

    private var sections: [Products] = []

    // MARK: - Lifecycle

    override func loadView() {
        view = viewFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
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

    private func loadProducts() {
        guard let path = Bundle.main.path(forResource: "Products", ofType: "json") else {
            print("Products.json not found")
            return
        }

        print("JSON file path: \(path)")

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            print("Loaded data: \(String(data: data, encoding: .utf8) ?? "No data")")

            let decodedResponse = try JSONDecoder().decode(SectionsResponse.self, from: data)
            sections = decodedResponse.sections
            print("Decoded sections: \(sections)")

            collectionView.reloadData()
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }


}

// MARK: - Extensions

extension ProductsListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("nr sectiuni \(sections.count)")
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("nr produse sectiuni \(sections[section].products.count)")
        return sections[section].products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueCell(withType: ProductCollectionViewCell.self, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        let product = sections[indexPath.section].products[indexPath.item]
        if let imageUrl = product.imageUrl,
           let url = URL(string: imageUrl) {
            cell.configure(with: .init(imageUrl: url, title: product.title, price: product.price))
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
        headerView.subviews.forEach { $0.removeFromSuperview() }
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 40))
        label.text = sections[indexPath.section].title
        label.textAlignment = .center
        headerView.addSubview(label)
        return headerView
    }
}

extension ProductsListViewController: UICollectionViewDelegate {

}

extension ProductsListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
}
