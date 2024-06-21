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
    
    // MARK: - Lifecycle

    override func loadView() {
        view = viewFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
    }
}

// MARK: - Extensions

extension ProductsListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
}

extension ProductsListViewController: UICollectionViewDelegate {

}
