//
//  FavoritesManager.swift
//  TVShows
//
//  Created by José Rodriguez Romero on 19/06/24.
//

import Foundation

class FavoritesManager {
    private(set) var favorites: [String: Bool] = [:]
    
    init() {
        loadFavorites()
    }
    
    func addFavorite(_ showName: String) {
        favorites[showName] = true
        updateLocalStorage()
    }
    
    func removeFavorite(_ showName: String) {
        favorites[showName] = false
        updateLocalStorage()
    }
    
    func isFavorite(_ showName: String) -> Bool {
        return favorites[showName] ?? false
    }
    
    private func updateLocalStorage() {
        UserDefaults.standard.set(favorites, forKey: "favorites")
    }
    
    private func loadFavorites() {
        if let savedFavorites = UserDefaults.standard.dictionary(forKey: "favorites") as? [String: Bool] {
            favorites = savedFavorites
        }
    }
}
