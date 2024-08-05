//
//  Product.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 21.06.2024.
//

import Foundation

struct Product: Codable, Hashable {
    let id: Int
    let title: String
    let price: Double
    let imageUrl: String?
    let description: String?
    var quantity: Int?
    let color: ProductColor?

    enum CodingKeys: String, CodingKey {
        case id, title, price, imageUrl = "image_url", description, quantity, color
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        price = try values.decode(Double.self, forKey: .price)
        imageUrl = try? values.decode(String.self, forKey: .imageUrl)
        description = try? values.decode(String.self, forKey: .description)
        quantity = try? values.decode(Int.self, forKey: .quantity)
        color = try? values.decode(ProductColor.self, forKey: .color)
    }
}
