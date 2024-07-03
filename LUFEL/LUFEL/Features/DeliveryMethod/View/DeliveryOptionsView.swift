//
//  DeliveryOptionsView.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 02.07.2024.
//

import UIKit
import Combine

enum DeliveryOption {
    case courier
    case easybox
    case pickup
}

class DeliveryOptionsView: UIView, NibLoadable {

    // MARK: - Views

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var courierOptionView: UIView!
    @IBOutlet weak var easyboxOptionView: UIView!
    @IBOutlet weak var pickupOptionView: UIView!

    // MARK: - Private properties

    lazy var courierOptionPublisher = courierOptionSubject.eraseToAnyPublisher()
    private let courierOptionSubject = PassthroughSubject<Void, Never>()

    lazy var easyboxOptionPublisher = easyboxOptionSubject.eraseToAnyPublisher()
    private let easyboxOptionSubject = PassthroughSubject<Void, Never>()

    lazy var pickupOptionPublisher = pickupOptionSubject.eraseToAnyPublisher()
    private let pickupOptionSubject = PassthroughSubject<Void, Never>()

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
        setupView()
    }

    // MARK: - Private methods

    private func setupView() {
        let courierTapGesture = UITapGestureRecognizer(target: self, action: #selector(courierOptionTapped))
        courierOptionView.addGestureRecognizer(courierTapGesture)

        let easyboxTapGesture = UITapGestureRecognizer(target: self, action: #selector(easyboxOptionTapped))
        easyboxOptionView.addGestureRecognizer(easyboxTapGesture)

        let pickupTapGesture = UITapGestureRecognizer(target: self, action: #selector(pickupOptionTapped))
        pickupOptionView.addGestureRecognizer(pickupTapGesture)
    }

    @objc private func courierOptionTapped() {
        courierOptionSubject.send()
    }

    @objc private func easyboxOptionTapped() {
        easyboxOptionSubject.send()
    }

    @objc private func pickupOptionTapped() {
        pickupOptionSubject.send()
    }
}
