//
//  CountySelectionViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 03.07.2024.
//

import UIKit
import Combine

class CountySelectionViewController: UIViewController {

    // MARK: - Views

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Private properties

    private var counties: [County] = []
    private lazy var dataSource = makeDataSource()
    private var cancellables = Set<AnyCancellable>()

    lazy var selectedCountyPublisher = selectedCountySubject.eraseToAnyPublisher()
    private let selectedCountySubject = PassthroughSubject<Void, Never>()

    @Injected(\.countyProvider) var countyProvider: CountyProviding

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        fetchCounties()
    }

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true)
    }

    // MARK: - Private methods

    private func setupView() {
        tableView.backgroundColor = .appBackground
        tableView.delegate = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(CountySelectionTableViewCell.self)
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }

    private func fetchCounties() {
        countyProvider.fetchCounties()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error fetching counties: \(error)")
                }
            }, receiveValue: { [weak self] counties in
                self?.counties = counties
                self?.applySnapshot()
            })
            .store(in: &cancellables)
    }

    private func makeDataSource() -> UITableViewDiffableDataSource<SingleSection, County> {
        return UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, county in
            guard let cell = tableView.dequeueReusableCell(of: CountySelectionTableViewCell.self, for: indexPath) as? CountySelectionTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: county.name)
            return cell
        }
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<SingleSection, County>()
        snapshot.appendSections([.main])
        snapshot.appendItems(counties)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension CountySelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCounty = counties[indexPath.row]
        let viewController = LocalitySelectionViewController(localities: selectedCounty.localities)
        present(viewController, animated: true, completion: nil)
    }
}
