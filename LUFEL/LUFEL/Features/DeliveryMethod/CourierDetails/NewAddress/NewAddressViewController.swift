//
//  NewAddressViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 03.07.2024.
//

import UIKit

class NewAddressViewController: UIViewController {

    // MARK: - Views

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var fullNameView: CustomPlaceholderTextView!
    @IBOutlet weak var phoneNumberView: CustomPlaceholderTextView!
    @IBOutlet weak var addressView: CustomPlaceholderTextView!
    @IBOutlet weak var countyView: UIView!
    @IBOutlet weak var countyAndLocalityLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Properties

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    // MARK: - Private methods

    private func setupCountyView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(countyViewTapped))
        countyView.addGestureRecognizer(tapGesture)
    }

    @objc private func countyViewTapped() {

    }
}
