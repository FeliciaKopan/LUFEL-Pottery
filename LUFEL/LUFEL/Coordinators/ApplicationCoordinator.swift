//
//  ApplicationCoordinator.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 05.06.2024.
//

import UIKit
import Combine

protocol Coordinator {
    func start()
}

final class ApplicationCoordinator: Coordinator {

    // MARK: - Private properties

    private var window: UIWindow?
    private let appNavigationController = AppNavigationController()
    private var coordinators: [Coordinator] = []
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(window: UIWindow) {
        self.window = window
        window.rootViewController = appNavigationController
        setupListeners()
    }

    // MARK: - Coordinator methods

    func start() {
        setupUnauthorizedApp()
    }

    // MARK: - Private methods

    private func setupUnauthorizedApp() {
        coordinators = []
        let unauthorizedCoordinator = UnauthorizedCoordinator(navigationController: appNavigationController)
        unauthorizedCoordinator.start()
        coordinators = [unauthorizedCoordinator]
    }

    private func setupListeners() {
        NotificationCenter.default.publisher(for: .logout)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.setupUnauthorizedApp()
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: .didCompleteLogin)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.setupActiveApp()
            }
            .store(in: &cancellables)
    }

    private func setupActiveApp() {
        UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        coordinators = []
        let authorizedCoordinator = MainAppCoordinator(navigationController: appNavigationController)
        authorizedCoordinator.start()
        coordinators = [authorizedCoordinator]
    }

    private func setRootTransition(to viewController: UIViewController) {
        guard let window = window else { return }
        window.rootViewController = viewController
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil,
            completion: nil
        )
    }
}

final class AppNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
        setViewControllers([SplashScreenViewController()], animated: false)
    }
}
