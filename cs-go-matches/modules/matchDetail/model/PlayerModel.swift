//
//  PlayerModel.swift
//  cs-go-matches
//
//  Created by Filipe Marques on 05/09/24.
//

import Foundation

struct PlayerModel: Codable, Identifiable {
    let id: Int
    let name: String
    let firstName: String?
    let imageUrl: String?
    let teamId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case firstName = "first_name"
        case imageUrl = "image_url"
        case teamId = "team_id"
    }
}
