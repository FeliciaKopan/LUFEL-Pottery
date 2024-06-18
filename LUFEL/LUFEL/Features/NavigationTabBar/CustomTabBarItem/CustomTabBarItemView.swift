//
//  CustomTabBarItemView.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 17.06.2024.
//

import UIKit

class CustomTabBarItemView: UIControl, NibLoadable {

    // MARK: - Views

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
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

    func set(image: UIImage) {
        imageView.image = image
    }

    func setImageDimensions(width: CGFloat, height: CGFloat) {
        imageWidthConstraint.constant = width
        imageHeightConstraint.constant = height
    }

    func setSelectedView(isSelected: Bool) {
        backgroundColor = isSelected ? .darkBrown : .lightGrey
    }
}
