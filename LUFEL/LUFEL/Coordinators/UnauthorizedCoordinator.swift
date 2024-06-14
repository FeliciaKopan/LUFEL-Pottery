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

    // MARK: - Coordinator methods

    @Injected(\.unauthorizedProvider) private var unauthorizedProvider: UnauthorizedProviding

    // MARK: - Init

    init(navigationController: AppNavigationController) {
        self.navigationController = navigationController
        setupStreams()
    }

    // MARK: - Coordinator methods

    // Set default view controller for coordinator
    func start() {
        let signUpViewController = LogInViewController()
        navigationController.setViewControllers([signUpViewController], animated: false)
    }

    private func goToSignInScreen() {
        let signInViewController = SignInViewController()
        navigationController.pushViewController(signInViewController, animated: true)
    }

    private func setupStreams() {
        unauthorizedProvider.goToPasswordSignInScreenPublisher
            .sink { [weak self] in
                self?.goToSignInScreen()
            }
            .store(in: &cancellables)
    }
}
