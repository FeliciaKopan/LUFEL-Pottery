//
//  SignUpViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 05.06.2024.
//

import UIKit

class LogInViewController: UIViewController {

    // MARK: - Views

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextField: CustomPlaceholderTextView!
    @IBOutlet weak var passwordTextField: CustomPlaceholderTextView!
    
    @Injected(\.unauthorizedProvider) private var unauthorizedProvider: UnauthorizedProviding

    // MARK: - Lifecycle

    override func loadView() {
        view = viewFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLabels()
    }

    @IBAction func logInButtonAction(_ sender: Any) {

    }

    @IBAction func signInButtonAction(_ sender: Any) {
        unauthorizedProvider.goToPasswordSignInScreen()
    }
    
    // MARK: - Private Properties

    private func setupLabels() {
        signUpButton.setTitle(L10n.SignUp.signInButton, for: .normal)
        logInButton.setTitle(L10n.SignUp.logInButton, for: .normal)
    }
}
