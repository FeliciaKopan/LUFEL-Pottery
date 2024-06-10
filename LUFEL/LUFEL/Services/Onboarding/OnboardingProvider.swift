//
//  OnboardingProvider.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 07.06.2024.
//

import Foundation
import Combine

final class OnboardingProvider: OnboardingProviding {

    // MARK: - Injected dependencies
//
//    @Injected(\.networkProvider) var networkProvider: NetworkProviding
//    @Injected(\.persistentContainerProvider) var persistentContainerProvider: PersistentContainerProviding

    // MARK: - OnboardingProviding

    lazy var didSetNamePublisher = didSetNameSubject.eraseToAnyPublisher()
    private let didSetNameSubject = PassthroughSubject<Void, Never>()

//    lazy var startOnboardingPublisher = startOnboardingSubject.eraseToAnyPublisher()
//    private let startOnboardingSubject = PassthroughSubject<UserProfile, Never>()

    func didSetName() {
        didSetNameSubject.send()
    }

//    func startOnboarding(_ user: UserProfile) {
//        startOnboardingSubject.send(user)
//    }
}

// MARK: - OnboardingProviderKey

private struct OnboardingProviderKey: InjectionKey {
    static var currentValue: OnboardingProviding = OnboardingProvider()
}

// MARK: - InjectedValues extension

extension InjectedValues {
    var onboardingProvider: OnboardingProviding {
        get { Self[OnboardingProviderKey.self] }
        set { Self[OnboardingProviderKey.self] = newValue }
    }
}


