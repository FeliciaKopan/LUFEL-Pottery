//
//  CartProviding.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 28.06.2024.
//

import Foundation

protocol CartProviding {
    func addProductToCart(_ product: Product)
    func removeProductFromCart(_ product: Product)
    func updateProductQuantity(_ product: Product)
    func getCartProducts() -> CartProducts
}
