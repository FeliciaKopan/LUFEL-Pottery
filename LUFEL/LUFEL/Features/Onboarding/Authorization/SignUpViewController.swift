//
//  SignUpViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 05.06.2024.
//

import UIKit

class SignUpViewController: UIViewController {

    // MARK: - Views

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    // MARK: - Lifecycle

    override func loadView() {
        view = viewFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()


    }
}
