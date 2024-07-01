//
//  UserProfileViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 14.06.2024.
//

import UIKit
import Combine

class UserProfileViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var editNameView: UIView!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var deleteAccountButton: UIView!

    // MARK: - Properties

    private let termsOfUseView = StackViewCellView()
    private let notificationsSwitch = StackViewCellView()
    private let supportSectionView = StackViewCellView()
    private let logoutView = StackViewCellView()

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle

    override func loadView() {
        view = viewFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (parent as? MainTabViewController)?.update(color: .black)
    }

    // MARK: - Actions

    @IBAction func closeProfile(_ sender: Any) {
    }
    
    @objc private func editName() {
        let editNameViewController = EditNameViewController()
        editNameViewController.modalPresentationStyle = .overFullScreen
        present(editNameViewController, animated: true)
    }

    @objc private func deleteAccount() {

    }

}
