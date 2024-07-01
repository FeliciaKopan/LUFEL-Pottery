//
//  CartProvider.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 28.06.2024.
//

import Foundation

final class CartProvider: CartProviding {

    private var cartProducts: CartProducts = CartProducts()

    init() {
        loadCart()
    }

    func addProductToCart(_ product: Product) {
        if let index = cartProducts.products.firstIndex(where: { $0.id == product.id }), let quantity = product.quantity {
            cartProducts.products[index].quantity! += quantity
        } else {
            var productToAdd = product
            if productToAdd.quantity == nil {
                productToAdd.quantity = 1
            }
            cartProducts.products.append(productToAdd)
        }
        updateTotalPrice()
        saveCart()
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }

    func removeProductFromCart(_ product: Product) {
        cartProducts.products.removeAll { $0.id == product.id }
        updateTotalPrice()
        saveCart()
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }

    func updateProductQuantity(_ cartProduct: Product) {
        if let index = cartProducts.products.firstIndex(where: { $0.id == cartProduct.id }) {
            cartProducts.products[index].quantity = cartProduct.quantity
            if cartProducts.products[index].quantity ?? 0 <= 0 {
                removeProductFromCart(cartProduct)
            } else {
                updateTotalPrice()
                saveCart()
                NotificationCenter.default.post(name: .cartUpdated, object: nil)
            }
        }
    }

    func getCartProducts() -> CartProducts {
        return cartProducts
    }

    private func updateTotalPrice() {
        cartProducts.totalPrice = cartProducts.products.reduce(0) { $0 + ($1.price * Double($1.quantity ?? 1)) }
    }

    private func saveCart() {
        do {
            let encoded = try JSONEncoder().encode(cartProducts)
            UserDefaults.standard.set(encoded, forKey: "cart")
            UserDefaults.standard.synchronize()
        } catch {
            print("Failed to save cart: \(error)")
        }
    }

    private func loadCart() {
        if let data = UserDefaults.standard.data(forKey: "cart"), let decoded = try? JSONDecoder().decode(CartProducts.self, from: data) {
            cartProducts = decoded
        } else {
            cartProducts = CartProducts()
        }
    }
}

private struct CartProviderKey: InjectionKey {
    static var currentValue: CartProviding = CartProvider()
}

// MARK: - InjectedValues extension

extension InjectedValues {
    var cartProvider: CartProviding {
        get { Self[CartProviderKey.self] }
        set { Self[CartProviderKey.self] = newValue }
    }
}
