//
//  SetNameViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 14.06.2024.
//

import UIKit

class SetNameViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func goToNextScreen(_ sender: Any) {
        let viewController = HomeViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
}
