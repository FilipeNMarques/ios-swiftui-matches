//
//  MatchDetail.swift
//  cs-go-matches
//
//  Created by Filipe Marques on 02/09/24.
//

import Foundation

struct MatchDetail: Codable {
    let beginAt: Date
    let opponents: [TeamDetail]

    enum CodingKeys: String, CodingKey {
        case opponents
        case beginAt = "begin_at"
    }
}

struct TeamDetail: Codable {
    let opponent: TeamInfo
}

struct TeamInfo: Codable {
    let id: Int
    let name: String
    let imageUrl: String?
    let players: [Player]

    enum CodingKeys: String, CodingKey {
        case id, name, players
        case imageUrl = "image_url"
    }
}

struct Player: Codable, Identifiable {
    let id: Int
    let firstName: String?
    let name: String
    let imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case firstName = "first_name"
        case imageUrl = "image_url"
    }
}
