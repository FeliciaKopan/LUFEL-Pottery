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
        let price: String
    }

    // MARK: - Views

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    // MARK: - Public methods

    func configure(with identifier: Identifier) {
        if let url = identifier.imageUrl {
            imageView.load(url: url)
        }
        titleLabel.text = identifier.title
        priceLabel.text = identifier.price
    }

}
