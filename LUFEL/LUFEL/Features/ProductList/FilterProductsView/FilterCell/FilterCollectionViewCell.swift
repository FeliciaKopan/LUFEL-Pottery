//
//  FilterCollectionViewCell.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 01.08.2024.
//

import UIKit

enum CellSelectionType {
    case selected
    case unselected
}

class FilterCollectionViewCell: UICollectionViewCell {

    // MARK: - Views

    @IBOutlet weak var filterLabel: UILabel!

    // MARK: - Properties

    private var isSelectedCell = false

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    // MARK: - Public methods

    func configure(title: String, isSelected: Bool = false) {
        filterLabel.text = title
        isSelectedCell = isSelected
        setSelected(isSelected ? .selected : .unselected)
    }

    func setSelected(_ type: CellSelectionType) {
        filterLabel.textColor = (type == .selected) ? .white : .black
        borderColor = (type == .selected) ? .black : .gray
        backgroundColor = (type == .selected) ? .darkGray : .clear
    }
}
