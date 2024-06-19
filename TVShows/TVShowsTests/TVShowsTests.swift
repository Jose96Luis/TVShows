//
//  TVShowsTests.swift
//  TVShowsTests
//
//  Created by José Rodriguez Romero on 19/06/24.
//

import XCTest
@testable import TVShows

final class TVShowsTests: XCTestCase {

    var favoritesManager: FavoritesManager!

    override func setUpWithError() throws {
        // Inicializa el FavoritesManager
        favoritesManager = FavoritesManager()
        // Limpia los favoritos antes de cada prueba
        UserDefaults.standard.removeObject(forKey: "favorites")
    }

    override func tearDownWithError() throws {
        // Limpia los favoritos después de cada prueba
        UserDefaults.standard.removeObject(forKey: "favorites")
        favoritesManager = nil
    }

    func testAddFavorite() throws {
        // Agrega un show a favoritos
        favoritesManager.addFavorite("Breaking Bad")
        // Verifica que el show esté en favoritos
        XCTAssertTrue(favoritesManager.isFavorite("Breaking Bad"), "El show debería estar en favoritos")
    }

    func testRemoveFavorite() throws {
        // Agrega y luego elimina un show de favoritos
        favoritesManager.addFavorite("Breaking Bad")
        favoritesManager.removeFavorite("Breaking Bad")
        // Verifica que el show no esté en favoritos
        XCTAssertFalse(favoritesManager.isFavorite("Breaking Bad"), "El show no debería estar en favoritos")
    }
}
