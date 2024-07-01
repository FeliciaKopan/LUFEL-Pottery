//
//  EditNameViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 01.07.2024.
//

import UIKit

class EditNameViewController: UIViewController {

    // MARK: - Views

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var setNameView: CustomPlaceholderTextView!
    @IBOutlet weak var saveNameButton: UIButton!
    @IBOutlet weak var saveButtonBottomConstraint: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    // MARK: - Actions

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func saveNameTapped(_ sender: Any) {
    }
    
}
