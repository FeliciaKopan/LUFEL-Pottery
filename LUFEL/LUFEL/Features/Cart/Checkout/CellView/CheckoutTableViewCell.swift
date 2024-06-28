//
//  CheckoutTableViewCell.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 28.06.2024.
//

import UIKit
import Combine

class CheckoutTableViewCell: UITableViewCell {

    struct Identifier {
        let imageUrl: URL?
        let title: String
        let quantity: Int
    }

    // MARK: - Views

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!

    // MARK: - Properties

    lazy var removeProductPublisher = removeProductSubject.eraseToAnyPublisher()
    private let removeProductSubject = PassthroughSubject<Void, Never>()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

    // MARK: - Actions

    @IBAction func removeProduct(_ sender: Any) {
        removeProductSubject.send()
    }
    
    // MARK: - Public methods

    func configure(with identifier: Identifier) {
        if let url = identifier.imageUrl {
            productImageView.load(url: url)
        }
        nameLabel.text = identifier.title
        quantityLabel.text = "\(identifier.quantity)"
    }
}
