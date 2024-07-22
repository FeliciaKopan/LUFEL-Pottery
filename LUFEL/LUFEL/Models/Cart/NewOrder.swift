//
//  NewOrder.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 22.07.2024.
//

import Foundation

struct NewOrder: Codable {
    var products: [Product]
    var paymentMethod: PaymentMethod?
    var shippingMethod: ShippingMethod?
    var address: String?

    enum CodingKeys: String, CodingKey {
        case products, paymentMethod, shippingMethod, address
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        products = try values.decode([Product].self, forKey: .products)
        paymentMethod = try? values.decode(PaymentMethod.self, forKey: .paymentMethod)
        shippingMethod = try? values.decode(ShippingMethod.self, forKey: .shippingMethod)
        address = try? values.decode(String.self, forKey: .address)
    }

    init(products: [Product] = [], payment: PaymentMethod? = .creditCard, shipping: ShippingMethod? = .courier, address: String? = nil) {
        self.products = products
        self.paymentMethod = payment
        self.shippingMethod = shipping
        self.address = address
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
