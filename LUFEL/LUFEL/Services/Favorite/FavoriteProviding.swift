//
//  FavoriteProviding.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 26.06.2024.
//

import Foundation

protocol FavoriteProviding {
    func addFavorite(_ product: Product)
    func removeFavorite(_ product: Product)
    func getFavorites() -> WishListProducts
}
