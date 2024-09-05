//
//  MatchParser.swift
//  cs-go-matches
//
//  Created by Filipe Marques on 04/09/24.
//

import Foundation

struct MatchParser {
    static func parse(json: [String: Any]) -> MatchListModel? {
        guard
            let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let status = json["status"] as? String
        else {
            print("Failed to parse basic match info")
            return nil
        }

        let beginAt: Date?
        if let beginAtString = json["begin_at"] as? String {
            let formatter = ISO8601DateFormatter()
            beginAt = formatter.date(from: beginAtString)
        } else {
            beginAt = nil
        }

        let league = parseLeague(from: json["league"] as? [String: Any], matchId: id)
        let serie = parseSerie(from: json["serie"] as? [String: Any], matchId: id)
        let opponents = parseOpponents(from: json["opponents"] as? [[String: Any]], matchId: id)

        return MatchListModel(
            id: id,
            name: name,
            status: status,
            beginAt: beginAt,
            opponents: opponents,
            league: league,
            serie: serie
        )
    }

    private static func parseLeague(from leagueData: [String: Any]?, matchId: Int) -> MatchListModel.League {
        guard
            let leagueData = leagueData,
            let leagueName = leagueData["name"] as? String
        else {
            print("Failed to parse league for match \(matchId)")
            return MatchListModel.League(name: "Unknown", imageUrl: nil)
        }
        let leagueImageUrl = leagueData["image_url"] as? String
        return MatchListModel.League(name: leagueName, imageUrl: leagueImageUrl)
    }

    private static func parseSerie(from serieData: [String: Any]?, matchId: Int) -> MatchListModel.Serie {
        guard
            let serieData = serieData,
            let serieName = serieData["name"] as? String
        else {
            print("Failed to parse serie for match \(matchId)")
            return MatchListModel.Serie(name: "Unknown")
        }
        return MatchListModel.Serie(name: serieName)
    }

    private static func parseOpponents(from opponentsData: [[String: Any]]?, matchId: Int) -> [MatchListModel.Team] {
        guard let opponentsData = opponentsData else {
            print("No opponents found for match \(matchId)")
            return []
        }

        return opponentsData.compactMap { opponentData in
            guard
                let opponent = opponentData["opponent"] as? [String: Any],
                let id = opponent["id"] as? Int,
                let name = opponent["name"] as? String
            else { return nil }

            let imageUrl = opponent["image_url"] as? String
            return MatchListModel.Team(id: id, name: name, imageUrl: imageUrl)
        }
    }
}
