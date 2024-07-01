//
//  UserProfileViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 14.06.2024.
//

import UIKit
import Combine

class UserProfileViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var editNameView: UIView!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var deleteAccountButton: UIView!

    // MARK: - Properties

    private let termsOfUseView = ProfileItem()
    private let notificationsSwitch = ProfileItem()
    private let supportSectionView = ProfileItem()
    private let logoutView = ProfileItem()

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Services

    @Injected(\.userProvider) var userProvider: UserProviding

    // MARK: - Lifecycle

    override func loadView() {
        view = viewFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupEditName()
        setupObservers()
        if let user = userProvider.user {
            updateUserName(user)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (parent as? MainTabViewController)?.update(color: .black)
    }

    // MARK: - Actions
    
    @objc private func editName() {
        let editNameViewController = EditNameViewController()
        editNameViewController.delegate = self
        editNameViewController.modalPresentationStyle = .overFullScreen
        present(editNameViewController, animated: true)
    }

    @objc private func deleteAccount() {

    }

    // MARK: - Private Methods

    private func setupObservers() {
        userProvider.userPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.updateUserName(user)
            }
            .store(in: &cancellables)
    }

    private func setupEditName() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editName))
        editNameView.addGestureRecognizer(tapGesture)
    }

    private func updateUserName(_ user: UserProfile) {
        userNameLabel.text = user.displayName
    }
}

extension UserProfileViewController: EditNameViewControllerDelegate {
    func didUpdateName(_ newName: String) {
        Task { @MainActor in
            if let updatedUser = await userProvider.setName(username: newName) {
                updateUserName(updatedUser)
            }
        }
    }

}
