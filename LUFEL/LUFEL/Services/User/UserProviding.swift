//
//  UserProviding.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 01.07.2024.
//

import Foundation
import Combine

protocol UserProviding {
    @MainActor func getUser() async -> UserProfile?
    @MainActor func setName(username: String) async -> UserProfile?
    var user: UserProfile? { get }
    var userPublisher: AnyPublisher<UserProfile, Never> { get }
}
