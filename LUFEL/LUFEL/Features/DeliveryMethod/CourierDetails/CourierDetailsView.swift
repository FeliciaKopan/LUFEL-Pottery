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

    private var addresses: [String] = []

    lazy var addNewAddressPublisher = addNewAddressSubject.eraseToAnyPublisher()
    private let addNewAddressSubject = PassthroughSubject<Void, Never>()

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
        tableView.backgroundColor = UIColor.black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(CourierDetailsTableViewCell.self)
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addNewAddressTapped))
        addAddressView.addGestureRecognizer(tapGesture)
    }

    private func addNewAddress(_ address: String) {
        addresses.append(address)
        tableView.reloadData()
    }

    @objc private func addNewAddressTapped() {
        addNewAddressSubject.send()
    }
}

extension CourierDetailsView: UITableViewDelegate {

}

extension CourierDetailsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(of: CourierDetailsTableViewCell.self, for: indexPath) as? CourierDetailsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: addresses[indexPath.row])
        return cell
    }
}
