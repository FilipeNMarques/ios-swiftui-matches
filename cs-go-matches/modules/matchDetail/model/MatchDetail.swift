//
//  MatchDetail.swift
//  cs-go-matches
//
//  Created by Filipe Marques on 02/09/24.
//

import Foundation

struct MatchDetailModel: Hashable {
    let id: Int
    let leagueName: String
    let serieName: String
    let opponents: [OpponentModel]
    let beginAt: Date?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(leagueName)
        hasher.combine(serieName)
        hasher.combine(opponents)
        hasher.combine(beginAt)
    }

    static func == (lhs: MatchDetailModel, rhs: MatchDetailModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.leagueName == rhs.leagueName &&
        lhs.serieName == rhs.serieName &&
        lhs.opponents == rhs.opponents &&
        lhs.beginAt == rhs.beginAt
    }
}

struct OpponentModel: Hashable {
    let id: Int
    let name: String
    let imageUrl: String?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(imageUrl)
    }

    static func == (lhs: OpponentModel, rhs: OpponentModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.imageUrl == rhs.imageUrl
    }
}
