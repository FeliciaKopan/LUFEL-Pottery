//
//  ProductCollectionViewCell.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 21.06.2024.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    // MARK: - Views

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    // MARK: - Public methods

    func configure(image: UIImage, title: String, price: String) {
        imageView.image = image
        titleLabel.text = title
        priceLabel.text = price
    }

}
