//
//  CartProducts.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 28.06.2024.
//

import Foundation

struct CartProducts: Codable, Hashable {
    var products: [Product]
    var paymentMethod: PaymentMethod?
    var shippingMethod: ShippingMethod?

    enum CodingKeys: String, CodingKey {
        case products, paymentMethod, shippingMethod
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        products = try values.decode([Product].self, forKey: .products)
        paymentMethod = try? values.decode(PaymentMethod.self, forKey: .paymentMethod)
        shippingMethod = try? values.decode(ShippingMethod.self, forKey: .shippingMethod)
    }

    init(products: [Product] = []) {
        self.products = products
    }
}

enum PaymentMethod: String, Codable {
    case creditCard
    case cashOnDelivery
}

enum ShippingMethod: String, Codable {
    case courier
    case easybox
    case pickup
}
