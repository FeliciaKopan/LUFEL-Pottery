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
    var addressDetails: AddressDetails?

    enum CodingKeys: String, CodingKey {
        case products, paymentMethod, shippingMethod, addressDetails
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        products = try values.decode([Product].self, forKey: .products)
        paymentMethod = try? values.decode(PaymentMethod.self, forKey: .paymentMethod)
        shippingMethod = try? values.decode(ShippingMethod.self, forKey: .shippingMethod)
        addressDetails = try? values.decode(AddressDetails.self, forKey: .addressDetails)
    }

    init(products: [Product] = [], payment: PaymentMethod? = .creditCard, shipping: ShippingMethod? = .courier, address: AddressDetails? = nil) {
        self.products = products
        self.paymentMethod = payment
        self.shippingMethod = shipping
        self.addressDetails = address
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
