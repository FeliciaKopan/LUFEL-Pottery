//
//  PasswordSignInViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 07.06.2024.
//

import UIKit

final class SignInViewController: UIViewController {

    // MARK: - Views

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailTextField: CustomPlaceholderTextView!
    @IBOutlet weak var passwordTextField: CustomPlaceholderTextView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    @Injected(\.onboardingProvider) private var onboardingProvider: OnboardingProviding

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    // MARK: - Button Action

    @IBAction func signInButtonAction(_ sender: Any) {
        let viewController = SetNameViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }

    @IBAction func goBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private Properties
}
