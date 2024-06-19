//
//  TVShowsManager.swift
//  TVShows
//
//  Created by José Rodriguez Romero on 18/06/24.
//

import Foundation

class TVShowsManager {
    static let shared = TVShowsManager()
    
    private var shows: [TVShow] = []
    
    private init() {
        loadShows { _ in }
    }
    
    func loadShows(completion: @escaping (Result<[TVShow], Error>) -> Void) {
        APIService.shared.fetchShows { result in
            switch result {
            case .success(let shows):
                self.shows = shows
                completion(.success(shows))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getShows() -> [TVShow] {
        return shows
    }
    
    func getFavoriteShows() -> [TVShow] {
        let favorites = UserDefaults.standard.dictionary(forKey: "favorites") as? [String: Bool] ?? [:]
        return shows.filter { favorites[$0.name] == true }
    }
}

