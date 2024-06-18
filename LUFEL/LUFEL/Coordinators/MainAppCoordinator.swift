//
//  MainAppCoordinator.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 05.06.2024.
//

import Combine
import UIKit

final class MainAppCoordinator: Coordinator {

    // MARK: - Properties

    private let navigationController: AppNavigationController
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(navigationController: AppNavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Coordinator methods

    // Set default view controller for coordinator
    func start() {
        let viewController = MainTabViewController()
        navigationController.setViewControllers([viewController], animated: true)
    }
}
