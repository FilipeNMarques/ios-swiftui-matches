//
//  MatchService.swift
//  cs-go-matches
//
//  Created by Filipe Marques on 02/09/24.
//

import Foundation

final class MatchService: MatchServiceProtocol {
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }

    func fetchMatches() async throws -> [MatchListModel] {
        let url = APIEndpoints.matches()
        let data = try await apiService.request(url)

        guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            throw NSError(domain: "MatchService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"])
        }

        let matches = jsonArray.compactMap { json -> MatchListModel? in
            let match = MatchParser.parse(json: json)
            if match == nil {
                print("Failed to parse match: \(json)")
            }
            return match
        }

        print("Parsed matches count: \(matches.count)")

        return matches
    }

    func fetchMatchDetails(matchId: Int) async throws -> [PlayerModel] {
        let url = APIEndpoints.matchDetails(id: matchId)
        let data = try await apiService.request(url)

        guard let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw NSError(domain: "MatchService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"])
        }

        guard let opponents = jsonDict["opponents"] as? [[String: Any]] else {
            throw NSError(domain: "MatchService", code: 0, userInfo: [NSLocalizedDescriptionKey: "No opponents found in response"])
        }

        var allPlayers: [PlayerModel] = []

        for opponent in opponents {
            guard let teamId = opponent["id"] as? Int,
                  let players = opponent["players"] as? [[String: Any]] else {
                continue
            }

            let teamPlayers = players.compactMap { playerJson -> PlayerModel? in
                PlayerParser.parse(json: playerJson, teamId: teamId)
            }

            allPlayers.append(contentsOf: teamPlayers)
        }

        print("Parsed players count: \(allPlayers.count)")

        return allPlayers
    }
}
