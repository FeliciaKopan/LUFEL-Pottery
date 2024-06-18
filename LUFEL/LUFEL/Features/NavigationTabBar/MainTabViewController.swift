//
//  MainTabViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 17.06.2024.
//

import UIKit

class MainTabViewController: UITabBarController {

    // MARK: - Views

    private var customTabBar = NavigationTabBar()

    // MARK: - Properties

    private var controllers: [UIViewController] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setTabBarViewControllers()
    }

    public func update(stylesheet: UIColor) {
        customTabBar.set(stylesheet: stylesheet)
    }

    // MARK: - Private methods

    private func setupViews() {
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().clipsToBounds = false
        customTabBar.delegate = self
        setValue(customTabBar, forKey: #keyPath(UITabBarController.tabBar))
    }

    private func setTabBarViewControllers() {
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = .init(title: "", image: nil, tag: 0)
        let cartViewController = CartViewController()
        cartViewController.tabBarItem = .init(title: "", image: nil, tag: 1)
        let emptyViewController = UIViewController()
        emptyViewController.tabBarItem.isEnabled = false
        let wishListViewController = WishListViewController()
        wishListViewController.tabBarItem = .init(title: "", image: nil, tag: 3)
        let profileViewController = UserProfileViewController()
        profileViewController.tabBarItem = .init(title: "", image: nil, tag: 4)

        controllers = [
            homeViewController,
            cartViewController,
            emptyViewController,
            wishListViewController,
            profileViewController
        ]

        viewControllers = controllers

        viewControllers?.forEach {
            let _ = $0.view
            $0.viewWillAppear(true)
        }
    }
}
