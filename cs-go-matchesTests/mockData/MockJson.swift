//
//  mockJson.swift
//  cs-go-matchesTests
//
//  Created by Filipe Marques on 04/09/24.
//

import Foundation

struct TestData {
    static let validMatchJSON: [String: Any] = [
        "id": 1,
        "name": "Team A vs Team B",
        "status": "running",
        "begin_at": "2024-09-04T15:00:00Z",
        "league": ["name": "Premier League", "image_url": "http://example.com/league.png"],
        "serie": ["name": "Spring Split"],
        "opponents": [
            ["opponent": ["id": 10, "name": "Team A", "image_url": "http://example.com/teamA.png"]],
            ["opponent": ["id": 20, "name": "Team B", "image_url": "http://example.com/teamB.png"]]
        ]
    ]

    static let invalidMatchJSON: [String: Any] = [
        "name": "Invalid Match",
        "status": "unknown"
    ]

    static let validMatchesResponse = """
    [
        {
            "id": 1,
            "name": "Team A vs Team B",
            "status": "running",
            "begin_at": "2024-09-04T15:00:00Z",
            "league": {"name": "Premier League", "image_url": "http://example.com/league.png"},
            "serie": {"name": "Spring Split"},
            "opponents": [
                {"opponent": {"id": 10, "name": "Team A", "image_url": "http://example.com/teamA.png"}},
                {"opponent": {"id": 20, "name": "Team B", "image_url": "http://example.com/teamB.png"}}
            ]
        }
    ]
    """
}
