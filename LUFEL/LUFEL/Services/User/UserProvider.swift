//
//  UserProvider.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 01.07.2024.
//

import Foundation
import Combine

final class UserProvider: UserProviding {

    // MARK: - Injected dependencies

    @Injected(\.networkProvider) var networkProvider: NetworkProviding

    // MARK: - Properties

    lazy var userPublisher: AnyPublisher<UserProfile, Never> = userSubject.eraseToAnyPublisher()
    private let userSubject = PassthroughSubject<UserProfile, Never>()

    var user: UserProfile? {
        didSet {
            guard let user = user else { return }
            userSubject.send(user)
        }
    }

    @MainActor func getUser() async -> UserProfile? {
        guard let url = Bundle.main.url(forResource: "UserProfile", withExtension: "json") else {
            print("Failed to locate UserProfile.json in bundle.")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let userProfile = try JSONDecoder().decode(UserProfile.self, from: data)
            self.user = userProfile
            return userProfile
        } catch {
            print("Failed to decode JSON: \(error)")
            return nil
        }
    }

    @MainActor func setName(username: String) async -> UserProfile? {
        user?.username = username
        user?.displayName = username
        if let user = user {
            userSubject.send(user)
        }
        return user
    }
}

private struct UserProviderKey: InjectionKey {
    static var currentValue: UserProviding = UserProvider()
}

// MARK: - InjectedValues extension

extension InjectedValues {
    var userProvider: UserProviding {
        get { Self[UserProviderKey.self] }
        set { Self[UserProviderKey.self] = newValue }
    }
}

