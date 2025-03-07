//
//  L10n.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 06.06.2024.
//

import Foundation

enum L10n {
    enum SignUp {
        static let signInButton = String(localized: "signUp.signInButton")
        static let logInButton = String(localized: "signUp.logInButton")
        static let email = String(localized: "signUp.email")
        static let password = String(localized: "signUp.password")
    }

    enum Cart {
        static let emptyTitle = String(localized: "cart.emptyTitle")
        static let addToCart = String(localized: "cart.addToCart")
    }

    enum ProductsList {
        static let emptyListTitle = String(localized: "productsList.emptyListTitle")
        static let emptyListDescription = String(localized: "productsList.emptyListDescription")
    }
}
