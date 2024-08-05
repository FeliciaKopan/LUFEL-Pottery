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

    func setSelected(_ type: CellType) {
        switch type {
        case .selected:
            filterLabel.textColor = .white
            borderColor = .black
            backgroundColor = .darkGray
        case .unselected:
            filterLabel.textColor = .black
            borderColor = .gray
            backgroundColor = .clear
        }
    }
}
