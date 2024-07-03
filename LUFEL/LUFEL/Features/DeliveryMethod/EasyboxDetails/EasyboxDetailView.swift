//
//  EasyboxDetailView.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 03.07.2024.
//

import UIKit

class EasyboxDetailView: UIView, NibLoadable {

    // MARK: - Views

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
