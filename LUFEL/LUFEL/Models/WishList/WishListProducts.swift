//
//  WishListProducts.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 26.06.2024.
//

import Foundation

struct WishListProducts: Codable, Hashable {
    var products: [Product]

    enum CodingKeys: String, CodingKey {
        case products
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        products = try values.decode([Product].self, forKey: .products)
    }

    init(products: [Product] = []) {
        self.products = products
    }
}
