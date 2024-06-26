//
//  FavoriteProvider.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 26.06.2024.
//

import Foundation

final class FavoriteProvider: FavoriteProviding {

    private var favorites: [Product] = []

    init() {
        loadFavorites()
    }

    func addFavorite(_ product: Product) {
        if !favorites.contains(where: { $0.id == product.id }) {
            favorites.append(product)
            saveFavorites()
        }
    }

    func removeFavorite(_ product: Product) {
        favorites.removeAll { $0.id == product.id }
        saveFavorites()
    }

    func getFavorites() -> [Product] {
        return favorites
    }

    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: "favorites")
        }
    }

    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favorites"),
           let decoded = try? JSONDecoder().decode([Product].self, from: data) {
            favorites = decoded
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
