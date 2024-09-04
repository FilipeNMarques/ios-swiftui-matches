//
//  MatchListModel.swift
//  cs-go-matches
//
//  Created by Filipe Marques on 02/09/24.
//

import Foundation

struct MatchListModel: Identifiable, Hashable {
    let id: Int
    let name: String
    let status: String
    let beginAt: Date?
    let opponents: [Team]
    let league: League
    let serie: Serie

    struct Team: Identifiable, Hashable {
        let id: Int
        let name: String
        let imageUrl: String?
    }

    struct League: Hashable {
        let name: String
        let imageUrl: String?
    }

    struct Serie: Hashable {
        let name: String
    }
}
