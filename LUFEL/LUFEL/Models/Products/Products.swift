//
//  Products.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 21.06.2024.
//

import Foundation

struct Products: Decodable {
    let title: String
    let products: [Product]

    enum CodingKeys: String, CodingKey {
        case title, products
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        products = try values.decode([Product].self, forKey: .products)
    }
}

struct SectionsResponse: Decodable {
    let sections: [Products]

    enum CodingKeys: String, CodingKey {
        case sections
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sections = try values.decode([Products].self, forKey: .sections)
    }
}
