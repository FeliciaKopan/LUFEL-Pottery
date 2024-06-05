//
//  UIViewControllerExtensions.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 05.06.2024.
//

import UIKit

extension UIViewController {

    func viewFromNib() -> UIView {
        let name = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        guard let view = bundle.loadNibNamed(name, owner: self, options: nil)?.first as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }

}
