//
//  MockAPIService.swift
//  cs-go-matchesTests
//
//  Created by Filipe Marques on 04/09/24.
//

import Foundation
@testable import cs_go_matches

class MockAPIService: APIServiceProtocol {
    var mockData: Data?
    var mockError: Error?

    func request(_ url: URL) async throws -> Data {
        if let error = mockError {
            throw error
        }
        return mockData ?? Data()
    }
}
