//
//  OnboardingProviding.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 07.06.2024.
//

import Foundation
import Combine

protocol OnboardingProviding {
    func didSetName()
//    func startOnboarding(_ user: UserProfile)
    var didSetNamePublisher: AnyPublisher<Void, Never> { get }
//    var startOnboardingPublisher: AnyPublisher<UserProfile, Never> { get }
}
