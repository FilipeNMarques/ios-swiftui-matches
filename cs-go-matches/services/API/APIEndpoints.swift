//
//  APIEndpoints.swift
//  cs-go-matches
//
//  Created by Filipe Marques on 02/09/24.
//

import Foundation

struct APIEndpoints {
    static let baseURL = "https://api.pandascore.co"

    static func matches(pageSize: Int = 5, sort: String = "-status") -> URL {
        URL(string: "\(baseURL)/csgo/matches?page[size]=\(pageSize)&sort=\(sort)")!
    }

    static func matchDetails(id: Int) -> URL {
        URL(string: "\(baseURL)/matches/\(id)/opponents")!
    }
}
