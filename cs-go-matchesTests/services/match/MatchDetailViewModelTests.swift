//
//  MatchDetailViewModelTests.swift
//  cs-go-matchesTests
//
//  Created by Filipe Marques on 05/09/24.
//

import XCTest

@testable import cs_go_matches

final class MatchDetailViewModelTests: XCTestCase {
    var sut: MatchDetailViewModel!
    var mockMatchService: MockMatchService!

    override func setUp() {
        super.setUp()
        let matchInfo = MatchDetailModel(
            id: 1,
            leagueName: "Test League",
            serieName: "Test Series",
            opponents: [
                OpponentModel(id: 1, name: "Team A", imageUrl: "http://example.com/teamA.png"),
                OpponentModel(id: 2, name: "Team B", imageUrl: "http://example.com/teamB.png")
            ],
            beginAt: Date()
        )
        mockMatchService = MockMatchService()
        sut = MatchDetailViewModel(matchInfo: matchInfo, matchService: mockMatchService)
    }

    override func tearDown() {
        sut = nil
        mockMatchService = nil
        super.tearDown()
    }

    func testFetchMatchDetailsSuccess() async {
        let player1 = PlayerModel(id: 1, name: "Player 1", firstName: "John", imageUrl: "http://example.com/player1.png", teamId: 1)
        let player2 = PlayerModel(id: 2, name: "Player 2", firstName: "Jane", imageUrl: "http://example.com/player2.png", teamId: 2)

        mockMatchService.mockPlayers = [player1, player2]

        await sut.fetchMatchDetails()

        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.playersByTeam.count, 2)
        XCTAssertEqual(sut.playersByTeam[1]?.count, 1)
        XCTAssertEqual(sut.playersByTeam[2]?.count, 1)
        XCTAssertEqual(sut.playersByTeam[1]?.first?.name, "Player 1")
        XCTAssertEqual(sut.playersByTeam[2]?.first?.name, "Player 2")
    }

    func testFetchMatchDetailsNetworkError() async {
        let underlyingError = NSError(domain: "test", code: 0, userInfo: nil)
        let expectedError = AppError.networkError(underlyingError)

        mockMatchService.mockError = expectedError

        await sut.fetchMatchDetails()

        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.error)
        XCTAssertTrue(sut.playersByTeam.isEmpty)

        if case .networkError(let receivedError) = sut.error {
            XCTAssertEqual(receivedError as NSError, underlyingError)
        } else {
            XCTFail("Unexpected error: \(String(describing: sut.error))")
        }
    }

    func testFetchMatchDetailsUnknownError() async {
        let unknownError = NSError(domain: "UnknownErrorDomain", code: 999, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])

        mockMatchService.mockError = AppError.unknown(unknownError.localizedDescription)

        await sut.fetchMatchDetails()

        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.error)
        XCTAssertTrue(sut.playersByTeam.isEmpty)

        if case .unknown(let errorDescription) = sut.error {
            XCTAssertEqual(errorDescription, unknownError.localizedDescription)
        } else {
            XCTFail("Unexpected error: \(String(describing: sut.error))")
        }
    }


}
