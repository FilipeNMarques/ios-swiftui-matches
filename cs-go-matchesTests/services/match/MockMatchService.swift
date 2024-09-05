//
//  MockMatchService.swift
//  cs-go-matchesTests
//
//  Created by Filipe Marques on 04/09/24.
//

import XCTest

@testable import cs_go_matches

class MockMatchService: MatchServiceProtocol {

    var mockMatches: [MatchListModel] = []
    var mockPlayers: [PlayerModel] = []
    var mockError: AppError?

    func fetchMatches() async throws -> [MatchListModel] {
        if let error = mockError {
            throw error
        }
        return mockMatches
    }

    func fetchMatchDetails(matchId: Int) async throws -> [PlayerModel] {
        if let error = mockError {
            throw error
        }
        return mockPlayers
    }
}
