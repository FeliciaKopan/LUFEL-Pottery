//
//  LocalitySelectionTableViewCell.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 03.07.2024.
//

import UIKit

class LocalitySelectionTableViewCell: UITableViewCell {

    // MARK: - Views

    @IBOutlet weak var localityLabel: UILabel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

    // MARK: - Public methods

    func configure(with county: String) {
        localityLabel.text = county
    }
}
