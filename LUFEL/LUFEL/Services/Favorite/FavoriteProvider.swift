//
//  FavoriteProvider.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 26.06.2024.
//

import Foundation

final class FavoriteProvider: FavoriteProviding {

    private var favorites: WishListProducts = WishListProducts()

    init() {
        loadFavorites()
    }

    func addFavorite(_ product: Product) {
        if !favorites.products.contains(where: { $0.id == product.id }) {
            favorites.products.append(product)
            saveFavorites()
        }
    }

    func removeFavorite(_ product: Product) {
        favorites.products.removeAll { $0.id == product.id }
        saveFavorites()
    }

    func getFavorites() -> WishListProducts {
        return favorites
    }

    private func saveFavorites() {
        do {
            let encoded = try JSONEncoder().encode(favorites)
            UserDefaults.standard.set(encoded, forKey: "favorites")
            UserDefaults.standard.synchronize()
        } catch {
            print("Failed to save favorites: \(error)")
        }
    }

    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favorites"),
           let decoded = try? JSONDecoder().decode(WishListProducts.self, from: data) {
            favorites = decoded
        } else {
            favorites = WishListProducts()
        }
    }
}

private struct FavoriteProviderKey: InjectionKey {
    static var currentValue: FavoriteProviding = FavoriteProvider()
}

// MARK: - InjectedValues extension

extension InjectedValues {
    var favoriteProvider: FavoriteProviding {
        get { Self[FavoriteProviderKey.self] }
        set { Self[FavoriteProviderKey.self] = newValue }
    }
}
