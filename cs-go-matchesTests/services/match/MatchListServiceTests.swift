//
//  MatchServiceTests.swift
//  cs-go-matchesTests
//
//  Created by Filipe Marques on 04/09/24.
//

import XCTest

@testable import cs_go_matches

final class MatchListServiceTests: XCTestCase {

    var sut: MatchService!
    var mockAPIService: MockAPIService!

    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        sut = MatchService(apiService: mockAPIService)
    }

    override func tearDown() {
        sut = nil
        mockAPIService = nil
        super.tearDown()
    }

    func testFetchMatchesReturnsSuccessWhenAPIReturnsValidData() async throws {
        mockAPIService.mockData = TestData.validMatchesResponse.data(using: .utf8)

        let matches = try await sut.fetchMatches()

        XCTAssertEqual(matches.count, 1)
        XCTAssertEqual(matches[0].id, 1)
        XCTAssertEqual(matches[0].name, "Team A vs Team B")
    }

    func testFetchMatchesThrowsErrorWhenAPIFails() async {
        struct TestError: Error {}

        mockAPIService.mockError = TestError()

        do {
            _ = try await sut.fetchMatches()
            XCTFail("Expected an error to be thrown")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
}

