//
//  AppError.swift
//  cs-go-matches
//
//  Created by Filipe Marques on 04/09/24.
//

import Foundation

enum AppError: Error, Equatable {
    case networkError(Error)
    case decodingError
    case invalidResponse
    case invalidData
    case unknown(String)

    static func == (lhs: AppError, rhs: AppError) -> Bool {
           switch (lhs, rhs) {
           case (.networkError(let lhsError), .networkError(let rhsError)):
               return lhsError.localizedDescription == rhsError.localizedDescription
           case (.decodingError, .decodingError),
                (.invalidResponse, .invalidResponse),
                (.invalidData, .invalidData):
               return true
           case (.unknown(let lhsString), .unknown(let rhsString)):
               return lhsString == rhsString
           default:
               return false
           }
       }
}
