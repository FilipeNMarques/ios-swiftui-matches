//
//  APIServiceTests.swift
//  cs-go-matchesTests
//
//  Created by Filipe Marques on 04/09/24.
//

import XCTest

@testable import cs_go_matches

final class APIServiceTests: XCTestCase {
    
    var sut: APIService!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        sut = APIService(session: mockURLSession)
    }
    
    override func tearDown() {
        sut = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    func testRequestReturnsDataWhenResponseIsSuccessful() async throws {
        let expectedData = "Test Data".data(using: .utf8)!
        
        mockURLSession.mockData = expectedData
        mockURLSession.mockResponse = HTTPURLResponse(url: URL(string: "https://api.example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let result = try await sut.request(URL(string: "https://api.example.com")!)
        
        XCTAssertEqual(result, expectedData)
    }
    
    func testRequestThrowsErrorWhenStatusCodeIsNot2xx() async {
        mockURLSession.mockData = Data()
        mockURLSession.mockResponse = HTTPURLResponse(url: URL(string: "https://api.example.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await sut.request(URL(string: "https://api.example.com")!)
            
            XCTFail("Expected an error to be thrown")
        } catch {
            XCTAssertTrue(error is URLError)
            XCTAssertEqual((error as? URLError)?.code, .badServerResponse)
        }
    }
    
    func testRequestAddsAuthorizationHeaderToRequest() async throws {
        let expectedData = "Test Data".data(using: .utf8)!
        
        mockURLSession.mockData = expectedData
        mockURLSession.mockResponse = HTTPURLResponse(url: URL(string: "https://api.example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        _ = try await sut.request(URL(string: "https://api.example.com")!)
        
        XCTAssertEqual(mockURLSession.lastRequest?.value(forHTTPHeaderField: "Authorization"), API.apiKey)
    }
    
    func testRequestThrowsErrorWhenSessionThrowsError() async {
        struct TestError: Error {}
        
        mockURLSession.mockError = TestError()
        
        do {
            _ = try await sut.request(URL(string: "https://api.example.com")!)
            XCTFail("Expected an error to be thrown")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
    
}
