//
//  Product.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 21.06.2024.
//

import Foundation

struct Product: Decodable, Hashable {
    let id: Int
    let title: String?
    let price: String?
    let imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case id, title, price, imageUrl = "image_url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String?.self, forKey: .title)
        price = try values.decode(String?.self, forKey: .price)
        imageUrl = try values.decode(String?.self, forKey: .imageUrl)
    }
}
