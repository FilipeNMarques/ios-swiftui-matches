//
//  MatchesListViewModelTests.swift
//  cs-go-matchesTests
//
//  Created by Filipe Marques on 04/09/24.
//

import XCTest

@testable import cs_go_matches

final class MatchesListViewModelTests: XCTestCase {
    var sut: MatchesListViewModel!
    var mockMatchService: MockMatchService!
    
    override func setUp() {
        super.setUp()
        mockMatchService = MockMatchService()
        sut = MatchesListViewModel(matchService: mockMatchService)
    }
    
    override func tearDown() {
        sut = nil
        mockMatchService = nil
        super.tearDown()
    }
    
    func testFetchMatchesReturnsValidMatchesWhenServiceSucceeds() async {
        let expectedMatches = [MatchListModel(id: 1, name: "Test Match", status: "upcoming", beginAt: Date(), opponents: [], league: .init(name: "Test League", imageUrl: nil), serie: .init(name: "Test Serie"))]
        
        mockMatchService.mockMatches = expectedMatches
        
        await sut.fetchMatches()
        
        XCTAssertEqual(sut.matches, expectedMatches)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
    }
    
    func testFetchMatchesUpdatesErrorStateWhenServiceFails() async {
        mockMatchService.mockError = AppError.networkError(NSError(domain: "test", code: 0, userInfo: nil))
        
        await sut.fetchMatches()
        
        XCTAssertTrue(sut.matches.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.error)
        
        if case .networkError = sut.error {
        } else {
            XCTFail("Unexpected error: \(String(describing: sut.error))")
        }
    }
    
    func testFetchMatchesHandlesAppErrorCorrectly() async throws {
        let expectedError = AppError.networkError(NSError(domain: "test", code: 0, userInfo: nil))
        
        mockMatchService.mockError = expectedError
        
        await sut.fetchMatches()
        
        XCTAssertEqual(sut.error, expectedError, "ViewModel should store the AppError")
        XCTAssertFalse(sut.isLoading, "isLoading should be false after fetch completes")
        XCTAssertTrue(sut.matches.isEmpty, "Matches should be empty when an error occurs")
    }
    
    func testFetchMatchesHandlesUnknownErrorCorrectly() async throws {
        let unknownError = NSError(domain: "UnknownErrorDomain", code: 999, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])
        
        mockMatchService.mockError = AppError.unknown(unknownError.localizedDescription)
        
        await sut.fetchMatches()
        
        if case .unknown(let errorDescription) = sut.error {
            XCTAssertEqual(errorDescription, unknownError.localizedDescription, "ViewModel should store unknown error description")
        } else {
            XCTFail("Error should be of type .unknown")
        }
        XCTAssertFalse(sut.isLoading, "isLoading should be false after fetch completes")
        XCTAssertTrue(sut.matches.isEmpty, "Matches should be empty when an error occurs")
    }
}
