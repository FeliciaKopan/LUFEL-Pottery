//
//  Products.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 21.06.2024.
//

import Foundation

struct ProductCategory: Decodable {
    let title: String
    let category: [Product]

    enum CodingKeys: String, CodingKey {
        case title, category
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        category = try values.decode([Product].self, forKey: .category)
    }
}

struct SectionsResponse: Decodable {
    let sections: [ProductCategory]

    enum CodingKeys: String, CodingKey {
        case sections
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sections = try values.decode([ProductCategory].self, forKey: .sections)
    }
}
