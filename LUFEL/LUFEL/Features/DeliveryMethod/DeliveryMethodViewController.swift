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
    @IBOutlet weak var deliveryDetailsView: UIView!
    
    // MARK: - Properties

    private var selectedOption: DeliveryOption?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

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
        deliveryDetailsView.subviews.forEach { $0.removeFromSuperview() }

        switch option {
        case .courier:
            break
        case .easybox, .pickup:
            break
        }
    }
}
