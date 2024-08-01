//
//  FilterCollectionViewCell.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 01.08.2024.
//

import UIKit

enum CellType {
    case selected
    case unselected
}

class FilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var filterLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    // MARK: - Public methods

    func configure(title: String) {
        filterLabel.text = title
        setSelected(.unselected)
    }

    func setSelected(_ type: CellType) {
        switch type {
        case .selected:
            filterLabel.textColor = .white
            borderColor = .black
            backgroundColor = .darkGray
        case .unselected:
            filterLabel.textColor = .lightGrey
            borderColor = .lightGrey
            backgroundColor = .clear
        }
    }

}
