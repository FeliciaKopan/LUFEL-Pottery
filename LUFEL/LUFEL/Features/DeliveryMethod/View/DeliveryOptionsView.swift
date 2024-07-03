//
//  DeliveryOptionsView.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 02.07.2024.
//

import UIKit
import Combine

class DeliveryOptionsView: UIView,  NibLoadable {

    // MARK: - Views

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var courieriOptionView: UIView!
    @IBOutlet weak var easyboxOptionView: UIView!
    @IBOutlet weak var pickupOptionView: UIView!

    // MARK: - Private properties

    private var cancellables = Set<AnyCancellable>()

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
