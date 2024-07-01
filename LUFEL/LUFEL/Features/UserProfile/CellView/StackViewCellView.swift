//
//  StackViewCellView.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 01.07.2024.
//

import UIKit
import Combine

class StackViewCellView: UIView, NibLoadable {

    // MARK: - Views

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var switchControl: UISwitch!
    
    // MARK: - Properties


    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
    }
}
