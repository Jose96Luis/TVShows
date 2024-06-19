//
//  TVShow.swift
//  TVShows
//
//  Created by José Rodriguez Romero on 18/06/24.
//

import Foundation

struct TVShow: Codable {
    let id: Int
    let name: String
    let summary: String
    let image: Image
    
    struct Image: Codable {
        let medium: String
        let original: String
    }
}
