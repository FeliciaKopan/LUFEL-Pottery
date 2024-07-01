//
//  AppConfig.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 01.07.2024.
//

import Foundation

public enum AppConfig {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist not found")
        }
        return dict
    }()

    static let baseURL: String = {
        guard let baseURL = AppConfig.infoDictionary[Keys.baseURL.rawValue] as? String else {
            fatalError("Base URL not set in plist")
        }
        return baseURL
    }()

    private enum Keys: String {
        case baseURL = "API_BASE_URL"
    }
}
