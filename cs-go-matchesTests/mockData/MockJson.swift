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

    static let validMatchDetailsJSON: [String: Any] = [
        "id": 1,
        "opponents": [
            [
                "id": 10,
                "players": [
                    [
                        "id": 101,
                        "name": "Player1",
                        "first_name": "John",
                        "image_url": "http://example.com/player1.png"
                    ],
                    [
                        "id": 102,
                        "name": "Player2",
                        "first_name": "Jane",
                        "image_url": "http://example.com/player2.png"
                    ]
                ]
            ],
            [
                "id": 20,
                "players": [
                    [
                        "id": 201,
                        "name": "Player3",
                        "first_name": "Bob",
                        "image_url": "http://example.com/player3.png"
                    ]
                ]
            ]
        ]
    ]

    static let invalidMatchDetailsJSON: [String: Any] = [
        "id": 1,
        "someOtherData": []
    ]
}
