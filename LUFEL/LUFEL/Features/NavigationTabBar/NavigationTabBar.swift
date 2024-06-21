//
//  NavigationTabBar.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 17.06.2024.
//

import UIKit
import Combine

class NavigationTabBar: UITabBar, NibLoadable {

    // MARK: - Views

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var homeView: CustomTabBarItemView!
    @IBOutlet weak var cartView: CustomTabBarItemView!
    @IBOutlet weak var listView: CustomTabBarItemView!
    @IBOutlet weak var wishListView: CustomTabBarItemView!
    @IBOutlet weak var profileView: CustomTabBarItemView!

    // MARK: - Properties

    private var tabBarItems: [UITabBarItem] = []
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        setupTabItemActions()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
        setupTabItemActions()
    }

    override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        addItems(items: items ?? [])
        super.setItems(items, animated: animated)
        bringSubviewToFront(stackView)
    }

    // MARK: - Public methods

    public func set(color: UIColor) {
        backgroundView.backgroundColor = UIColor.tintColor
    }

    // MARK: - Private methods

    private func setupTabItemActions() {
        homeView.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.tabBarItemTap(sender: self.homeView)
            }.store(in: &cancellables)
        cartView.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.tabBarItemTap(sender: self.cartView)
            }.store(in: &cancellables)
        listView.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.tabBarItemTap(sender: self.listView)
            }.store(in: &cancellables)
        wishListView.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.tabBarItemTap(sender: self.wishListView)
            }.store(in: &cancellables)
        profileView.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.tabBarItemTap(sender: self.profileView)
            }.store(in: &cancellables)
    }

    private func addItems(items: [UITabBarItem]) {
        tabBarItems = items
        items.enumerated().forEach { (index, item) in
            switch index {
            case 0:
                homeView.tag = index
                homeView.set(image: .home)
                homeView.setSelectedView(isSelected: true)
            case 1:
                cartView.tag = index
                cartView.set(image: .cart)
                cartView.setSelectedView(isSelected: false)
            case 2:
                listView.tag = index
                listView.set(image: .menuList)
                listView.setSelectedView(isSelected: false)
            case 3:
                wishListView.tag = index
                wishListView.set(image: .wishlist)
                wishListView.setSelectedView(isSelected: false)
            case 4:
                profileView.tag = index
                profileView.set(image: .profile)
                profileView.setSelectedView(isSelected: false)
            default:
                break
            }
        }
    }

    @objc private func tabBarItemTap(sender: CustomTabBarItemView) {
        stackView.arrangedSubviews.map { $0 as? CustomTabBarItemView }.forEach {
            $0?.setSelectedView(isSelected: false)
        }
        sender.setSelectedView(isSelected: true)
        if sender.tag < tabBarItems.count {
            delegate?.tabBar?(self, didSelect: tabBarItems[sender.tag])
        }
    }

}
