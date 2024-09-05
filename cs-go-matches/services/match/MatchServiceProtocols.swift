//
//  MatchServiceProtocols.swift
//  cs-go-matches
//
//  Created by Filipe Marques on 02/09/24.
//

import Foundation

protocol MatchesListServiceProtocol {
    func fetchMatches() async throws -> [MatchListModel]
}

protocol MatchDetailServiceProtocol {
    func fetchMatchDetails(matchId: Int) async throws -> [PlayerModel]
}

typealias MatchServiceProtocol = MatchesListServiceProtocol & MatchDetailServiceProtocol
