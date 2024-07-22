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
    @IBOutlet weak var goBackView: UIView!
    
    // MARK: - Properties

    private var newOrder: NewOrder
    private var selectedOption: DeliveryOption?
    private var cancellables = Set<AnyCancellable>()

    @Injected(\.cartProvider) var cartProvider: CartProviding

    // MARK: - Initializer

    init(newOrder: NewOrder) {
        self.newOrder = newOrder
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupListeners()
        didSelectOption(.courier)
        setupNavigationBar()
    }

    @IBAction func continueButtonTapped(_ sender: Any) {
        if let selectedOption = selectedOption {
            switch selectedOption {
            case .courier:
                newOrder.shippingMethod = .courier
            case .easybox:
                newOrder.shippingMethod = .easybox
            case .pickup:
                newOrder.shippingMethod = .pickup
            }
        }
        let viewController = CheckoutViewController(newOrder: newOrder)
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func goBack() {
        dismiss(animated: true)
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

        courierDetailsView.addNewAddressPublisher
            .sink { [weak self] in
                guard let newOrder = self?.newOrder else { return }
                let viewController = NewAddressViewController(newOrder: newOrder)
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
            .store(in: &cancellables)
    }

    private func didSelectOption(_ option: DeliveryOption) {
        selectedOption = option
        showDeliveryDetails(for: option)
        deliveryOptionsView.updateBackgroundColor(for: option)
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

    private func setupNavigationBar() {
        navigationItem.title = "Metoda de livrare"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(goBack)
        )

        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
    }
}
