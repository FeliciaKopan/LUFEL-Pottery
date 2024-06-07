//
//  UnauthorizedProviding.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 07.06.2024.
//

import Foundation
import Combine

protocol UnauthorizedProviding {
    func goToPasswordSignInScreen()
    var goToPasswordSignInScreenPublisher: AnyPublisher<Void, Never> { get }
}
