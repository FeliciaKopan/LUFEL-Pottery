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
    private var cancellables = Set<AnyCancellable>()

    @Injected(\.countyProvider) var countyProvider: CountyProviding

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        fetchCounties()
    }

    // MARK: - Private methods

    private func setupView() {
        tableView.backgroundColor = UIColor.black
        tableView.delegate = self
        tableView.dataSource = self
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
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)
    }
}

extension CountySelectionViewController: UITableViewDelegate {

}

extension CountySelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(of: CountySelectionTableViewCell.self, for: indexPath) as? CountySelectionTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: counties[indexPath.row].name)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCounty = counties[indexPath.row]
        let viewController = LocalitySelectionViewController(localities: selectedCounty.localities)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
