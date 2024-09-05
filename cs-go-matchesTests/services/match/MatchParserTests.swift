//
//  MatchParserTests.swift
//  cs-go-matchesTests
//
//  Created by Filipe Marques on 04/09/24.
//

import XCTest

@testable import cs_go_matches

final class MatchParserTests: XCTestCase {
    
    func testParseValidMatch() {
        let json = TestData.validMatchJSON
        let match = MatchParser.parse(json: json)
        
        XCTAssertNotNil(match)
        XCTAssertEqual(match?.id, 1)
        XCTAssertEqual(match?.name, "Team A vs Team B")
        XCTAssertEqual(match?.status, "running")
        XCTAssertEqual(match?.beginAt?.timeIntervalSince1970, 1725462000)
        XCTAssertEqual(match?.league.name, "Premier League")
        XCTAssertEqual(match?.league.imageUrl, "http://example.com/league.png")
        XCTAssertEqual(match?.serie.name, "Spring Split")
        XCTAssertEqual(match?.opponents.count, 2)
        XCTAssertEqual(match?.opponents[0].name, "Team A")
        XCTAssertEqual(match?.opponents[1].name, "Team B")
    }
    
    func testParseInvalidMatch() {
        let json = TestData.invalidMatchJSON
        let match = MatchParser.parse(json: json)
        
        XCTAssertNil(match)
    }
}
