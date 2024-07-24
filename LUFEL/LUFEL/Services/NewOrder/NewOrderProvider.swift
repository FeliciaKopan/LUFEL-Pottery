//
//  NewOrderProvider.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 22.07.2024.
//

import Foundation

class OrderProvider: OrderProviding {
    var currentOrder: NewOrder

    init(products: [Product]) {
        self.currentOrder = NewOrder(products: products, paymentMethod: nil, shippingMethod: nil, address: nil)
    }
}
