//
//  LocalitySelectionViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 03.07.2024.
//

import UIKit

class LocalitySelectionViewController: UIViewController {

    // MARK: - Views

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties

    private let localities: [String]

    // MARK: - Init

    init(localities: [String]) {
        self.localities = localities
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    // MARK: - Private methods

    private func setupTableView() {
        tableView.backgroundColor = UIColor.black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(LocalitySelectionTableViewCell.self)
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension LocalitySelectionViewController: UITableViewDelegate {

}

extension LocalitySelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(of: LocalitySelectionTableViewCell.self, for: indexPath) as? LocalitySelectionTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: localities[indexPath.row])
        return cell
    }
}
