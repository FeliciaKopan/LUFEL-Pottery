//
//  EmptyStateView.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 12.07.2024.
//

import UIKit

class EmptyStateView: UIView, NibLoadable {

    // MARK: - Views

    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()

    }

    // MARK: - Public methods

    func configure(title: String) {
        titleLabel.text = title
    }

}
