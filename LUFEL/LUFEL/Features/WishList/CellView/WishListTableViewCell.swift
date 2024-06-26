//
//  WishListTableViewCell.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 26.06.2024.
//

import UIKit

class WishListTableViewCell: UITableViewCell {

    struct Identifier {
        let imageUrl: URL?
        let title: String
        let price: String
        let description: String?
    }

    // MARK: - Views
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

    // MARK: - Actions

    @IBAction func deleteProduct(_ sender: Any) {
    }
    
    @IBAction func addProductToCart(_ sender: Any) {
    }

    // MARK: - Public methods

    func configure(with identifier: Identifier) {
        if let url = identifier.imageUrl, let description = identifier.description {
            productImageView.load(url: url)
            descriptionLabel.text = description
        }
        nameLabel.text = identifier.title
        priceLabel.text = identifier.price
    }

    // MARK: - Private methods

}
