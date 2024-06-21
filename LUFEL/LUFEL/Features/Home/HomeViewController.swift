//
//  HomeViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 14.06.2024.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Lifecycle

    override func loadView() {
        view = viewFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (parent as? MainTabViewController)?.update(color: .red)
    }
}
