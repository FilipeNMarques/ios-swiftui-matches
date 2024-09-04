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
}
