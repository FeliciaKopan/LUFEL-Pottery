//
//  CourierDetailsView.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 03.07.2024.
//

import UIKit
import Combine

class CourierDetailsView: UIView, NibLoadable {

    // MARK: - Views

    @IBOutlet weak var addAddressView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private properties

    private var addresses: [AddressDetails] = []
    
    @Injected(\.addressProvider) var addressProvider: AddressProviding

    lazy var addNewAddressPublisher = addNewAddressSubject.eraseToAnyPublisher()
    private let addNewAddressSubject = PassthroughSubject<Void, Never>()

    lazy var selectedAddressPublisher = selectedAddressSubject.eraseToAnyPublisher()
    private let selectedAddressSubject = PassthroughSubject<AddressDetails, Never>()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        setupView()
        loadAddresses()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
        setupView()
        loadAddresses()
    }

    // MARK: - Public methods

    func addNewAddress(_ address: AddressDetails) {
        addresses.insert(address, at: 0)
        addressProvider.addAddress(address)
        loadAddresses()
        tableView.reloadData()
    }

    // MARK: - Private methods

    private func setupView() {
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(CourierDetailsTableViewCell.self)
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addNewAddressTapped))
        addAddressView.addGestureRecognizer(tapGesture)
    }

    private func removeAddress(at indexPath: IndexPath) {
        let address = addresses.remove(at: indexPath.row)
        addressProvider.removeAddress(address)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    private func loadAddresses() {
        addresses = addressProvider.getAddresses()
        tableView.reloadData()
    }

    @objc private func addNewAddressTapped() {
        addNewAddressSubject.send()
    }
}

extension CourierDetailsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            self?.removeAddress(at: indexPath)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAddress = addresses[indexPath.row]
        selectedAddressSubject.send(selectedAddress)
    }
}

extension CourierDetailsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(of: CourierDetailsTableViewCell.self, for: indexPath) as? CourierDetailsTableViewCell else {
            return UITableViewCell()
        }
        let addressDetails = addresses[indexPath.row]
        cell.configure(with: addressDetails)
        return cell
    }
}
