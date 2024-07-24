//
//  CourierDetailsTableViewCell.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 03.07.2024.
//

import UIKit

class CourierDetailsTableViewCell: UITableViewCell {

    struct Identifier {
        let fullName: String
        let phoneNumber: String
        let address: String
        let county: String
        let locality: String
    }

    // MARK: - Views

    @IBOutlet weak var personalDetailsLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var countyLabel: UILabel!
    
    // MARK: - Properties

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

    // MARK: - Public methods

    func configure(with addressDetails: AddressDetails) {
        personalDetailsLabel.text = addressDetails.fullName
        phoneNumberLabel.text = addressDetails.phoneNumber
        addressLabel.text = addressDetails.address
        countyLabel.text = "\(addressDetails.county), \(addressDetails.locality)"
    }
}
