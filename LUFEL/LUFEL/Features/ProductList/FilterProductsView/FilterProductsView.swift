//
//  FilterProductsView.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 01.08.2024.
//

import UIKit

class FilterProductsView: UIView, NibLoadable {

    // MARK: - Views

    @IBOutlet weak var typeFilterView: UIView!
    @IBOutlet weak var colorFilterView: UIView!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var showAllButton: UIButton!

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
    }

    // MARK: - Private methods

}
