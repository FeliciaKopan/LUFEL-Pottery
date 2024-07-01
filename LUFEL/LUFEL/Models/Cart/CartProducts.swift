//
//  CartProducts.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 28.06.2024.
//

import Foundation

struct CartProducts: Codable, Hashable {
    var products: [Product]
    var totalPrice: Double

    enum CodingKeys: String, CodingKey {
        case products, totalPrice
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        products = try values.decode([Product].self, forKey: .products)
        totalPrice = try values.decode(Double.self, forKey: .totalPrice)
    }

    init(products: [Product] = [], totalPrice: Double = 0.0) {
        self.products = products
        self.totalPrice = totalPrice
    }
}
