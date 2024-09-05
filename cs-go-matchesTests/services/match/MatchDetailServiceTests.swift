//
//  MatchDetailServiceTests.swift
//  cs-go-matchesTests
//
//  Created by Filipe Marques on 05/09/24.
//

import XCTest
@testable import cs_go_matches

final class MatchDetailServiceTests: XCTestCase {

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

    func testFetchMatchDetailsReturnsSuccessWhenAPIReturnsValidData() async throws {
        let validMatchDetailsResponse = try JSONSerialization.data(withJSONObject: TestData.validMatchDetailsJSON)

        mockAPIService.mockData = validMatchDetailsResponse

        let players = try await sut.fetchMatchDetails(matchId: 1)

        XCTAssertEqual(players.count, 3)
        XCTAssertEqual(players[0].id, 101)
        XCTAssertEqual(players[0].name, "Player1")
        XCTAssertEqual(players[0].firstName, "John")
        XCTAssertEqual(players[0].imageUrl, "http://example.com/player1.png")
        XCTAssertEqual(players[0].teamId, 10)
        XCTAssertEqual(players[2].id, 201)
        XCTAssertEqual(players[2].name, "Player3")
        XCTAssertEqual(players[2].firstName, "Bob")
        XCTAssertEqual(players[2].imageUrl, "http://example.com/player3.png")
        XCTAssertEqual(players[2].teamId, 20)
    }

    func testFetchMatchDetailsThrowsErrorWhenAPIFails() async {
        struct TestError: Error {}

        mockAPIService.mockError = TestError()

        do {
            _ = try await sut.fetchMatchDetails(matchId: 1)
            XCTFail("Expected an error to be thrown")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }

    func testFetchMatchDetailsThrowsErrorWhenJSONIsInvalid() async {
        mockAPIService.mockData = "Invalid JSON".data(using: .utf8)

        do {
            _ = try await sut.fetchMatchDetails(matchId: 1)
            XCTFail("Expected an error to be thrown")
        } catch let error as NSError {
            XCTAssertEqual(error.domain, NSCocoaErrorDomain)
            XCTAssertEqual(error.code, 3840)
        }
    }

    func testFetchMatchDetailsThrowsErrorWhenNoOpponentsFound() async {
        let invalidResponse = try! JSONSerialization.data(withJSONObject: TestData.invalidMatchDetailsJSON)

        mockAPIService.mockData = invalidResponse

        do {
            _ = try await sut.fetchMatchDetails(matchId: 1)
            XCTFail("Expected an error to be thrown")
        } catch let error as NSError {
            XCTAssertEqual(error.domain, "MatchService")
            XCTAssertEqual(error.code, 0)
            XCTAssertEqual(error.userInfo[NSLocalizedDescriptionKey] as? String, "No opponents found in response")
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
