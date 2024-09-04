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

protocol MatchDetailServiceProtocol {}

typealias MatchServiceProtocol = MatchesListServiceProtocol
