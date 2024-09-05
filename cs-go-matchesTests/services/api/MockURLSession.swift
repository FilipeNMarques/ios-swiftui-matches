//
//  MockURLSession.swift
//  cs-go-matchesTests
//
//  Created by Filipe Marques on 04/09/24.
//

import Foundation

@testable import cs_go_matches

final class MockURLSession: URLSessionProtocol {

    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    var lastRequest: URLRequest?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        lastRequest = request

        if let error = mockError {
            throw error
        }
        return (mockData ?? Data(), mockResponse ?? URLResponse())
    }
}
