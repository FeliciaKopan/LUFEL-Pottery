//
//  UnauthorizedProvider.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 07.06.2024.
//

import Foundation
import Combine

final class UnauthorizedProvider: UnauthorizedProviding {

    lazy var goToPasswordSignInScreenPublisher = goToPasswordSignInScreenSubject.eraseToAnyPublisher()
    private let goToPasswordSignInScreenSubject = PassthroughSubject<Void, Never>()

    func goToPasswordSignInScreen() {
        goToPasswordSignInScreenSubject.send()
    }
}

// MARK: - UnauthorizedProviderKey

private struct UnauthorizedProviderKey: InjectionKey {
    static var currentValue: UnauthorizedProviding = UnauthorizedProvider()
}

// MARK: - InjectedValues extension

extension InjectedValues {
    var unauthorizedProvider: UnauthorizedProviding {
        get { Self[UnauthorizedProviderKey.self] }
        set { Self[UnauthorizedProviderKey.self] = newValue }
    }
}
