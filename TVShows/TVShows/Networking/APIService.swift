//
//  APIService.swift
//  TVShows
//
//  Created by José Rodriguez Romero on 18/06/24.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func fetchShows(completion: @escaping (Result<[TVShow], Error>) -> Void) {
        guard let url = URL(string: "https://api.tvmaze.com/shows") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            do {
                let shows = try JSONDecoder().decode([TVShow].self, from: data)
                completion(.success(shows))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
