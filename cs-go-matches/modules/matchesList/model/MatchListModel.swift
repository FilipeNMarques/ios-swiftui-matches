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

    struct Team: Identifiable, Hashable {
        let id: Int
        let name: String
        let imageUrl: String?

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: Team, rhs: Team) -> Bool {
            lhs.id == rhs.id
        }
    }

    struct League: Hashable {
        let name: String
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: MatchListModel, rhs: MatchListModel) -> Bool {
        lhs.id == rhs.id
    }
}

class MatchParser {
    static func parse(json: [String: Any]) -> MatchListModel? {
        guard
            let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let status = json["status"] as? String,
            let leagueData = json["league"] as? [String: Any],
            let leagueName = leagueData["name"] as? String
        else {
            return nil
        }

        let beginAt: Date?
        if let beginAtString = json["begin_at"] as? String {
            let formatter = ISO8601DateFormatter()
            beginAt = formatter.date(from: beginAtString)
        } else {
            beginAt = nil
        }

        let league = MatchListModel.League(name: leagueName)

        var opponents: [MatchListModel.Team] = []
        if let opponentsData = json["opponents"] as? [[String: Any]] {
            for opponentData in opponentsData {
                if let opponent = opponentData["opponent"] as? [String: Any],
                   let id = opponent["id"] as? Int,
                   let name = opponent["name"] as? String {
                    let imageUrl = opponent["image_url"] as? String
                    let team = MatchListModel.Team(id: id, name: name, imageUrl: imageUrl)
                    opponents.append(team)
                }
            }
        }

        return MatchListModel(id: id, name: name, status: status, beginAt: beginAt, opponents: opponents, league: league)
    }
}
