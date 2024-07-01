//
//  UserProfile.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 01.07.2024.
//

import Foundation

struct UserProfile: Decodable {
    let id: Int
    var username: String
    let email: String
    var displayName: String?

    enum CodingKeys: String, CodingKey {
        case id, username, email, displayName
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        username = try values.decode(String.self, forKey: .username)
        email = try values.decode(String.self, forKey: .email)
        displayName = try? values.decode(String.self, forKey: .displayName)
    }
}
