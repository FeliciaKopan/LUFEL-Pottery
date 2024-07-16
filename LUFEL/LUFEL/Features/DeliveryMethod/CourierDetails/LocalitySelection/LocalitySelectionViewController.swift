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
    private lazy var dataSource = makeDataSource()

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
        applySnapshot()
    }

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Private methods

    private func setupTableView() {
        tableView.backgroundColor = .appBackground
        tableView.delegate = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(LocalitySelectionTableViewCell.self)
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }

    private func makeDataSource() -> UITableViewDiffableDataSource<SingleSection, String> {
        return UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, locality in
            guard let cell = tableView.dequeueReusableCell(of: LocalitySelectionTableViewCell.self, for: indexPath) as? LocalitySelectionTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: locality)
            return cell
        }
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<SingleSection, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(localities)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension LocalitySelectionViewController: UITableViewDelegate {

}
