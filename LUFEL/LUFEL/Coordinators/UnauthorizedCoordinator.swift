//
//  UnauthorizedCoordinator.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 05.06.2024.
//

import UIKit
import Combine

final class UnauthorizedCoordinator: Coordinator {

    // MARK: - Properties

    private let navigationController: AppNavigationController
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(navigationController: AppNavigationController) {
        self.navigationController = navigationController
//        setupStreams()
    }

    // MARK: - Coordinator methods

    // Set default view controller for coordinator
    func start() {
        let signUpViewController = SignUpViewController()
        navigationController.setViewControllers([signUpViewController], animated: false)
    }

    private func goToSignUpScreen() {
        let signUpViewController = SignUpViewController()
        navigationController.pushViewController(signUpViewController, animated: true)
    }
}
