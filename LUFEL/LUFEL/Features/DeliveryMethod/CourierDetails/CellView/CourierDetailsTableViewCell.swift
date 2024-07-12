//
//  CourierDetailsTableViewCell.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 03.07.2024.
//

import UIKit

class CourierDetailsTableViewCell: UITableViewCell {

    struct Identifier {
        let userName: String
        let phoneNumber: String
        let address: String
    }

    // MARK: - Views

    @IBOutlet weak var personalDetailsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    // MARK: - Properties

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

    // MARK: - Public methods

    func configure(with address: String) {
        addressLabel.text = address
    }

}
