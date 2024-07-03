//
//  DeliveryMethodViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 02.07.2024.
//

import UIKit
import Combine

class DeliveryMethodViewController: UIViewController {

    // MARK: - Views

    @IBOutlet weak var deliveryOptionsView: DeliveryOptionsView!
    @IBOutlet weak var courierDetailsView: CourierDetailsView!
    @IBOutlet weak var easyboxDetailsView: EasyboxDetailView!
    @IBOutlet weak var pickupDetailsView: PickupDetailView!

    // MARK: - Properties

    private var selectedOption: DeliveryOption?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupListeners()
        didSelectOption(.courier)
    }

    // MARK: - Private methods

    private func setupListeners() {
        deliveryOptionsView.courierOptionPublisher
            .sink { [weak self] in
                self?.didSelectOption(.courier)
            }
            .store(in: &cancellables)

        deliveryOptionsView.easyboxOptionPublisher
            .sink { [weak self] in
                self?.didSelectOption(.easybox)
            }
            .store(in: &cancellables)

        deliveryOptionsView.pickupOptionPublisher
            .sink { [weak self] in
                self?.didSelectOption(.pickup)
            }
            .store(in: &cancellables)
    }

    private func didSelectOption(_ option: DeliveryOption) {
        selectedOption = option
        showDeliveryDetails(for: option)
    }

    private func showDeliveryDetails(for option: DeliveryOption) {
        courierDetailsView.isHidden = true
        easyboxDetailsView.isHidden = true
        pickupDetailsView.isHidden = true

        switch option {
        case .courier:
            courierDetailsView.isHidden = false
        case .easybox:
            easyboxDetailsView.isHidden = false
        case .pickup:
            pickupDetailsView.isHidden = false
        }
    }
}
