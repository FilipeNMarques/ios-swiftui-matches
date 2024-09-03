//
//  EnvConfigurations.swift
//  cs-go-matches
//
//  Created by Filipe Marques on 02/09/24.
//

import Foundation

enum Configuration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey:key) else {
            throw Error.missingKey
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { throw Error.invalidValue }
            return value
        default:
            throw Error.invalidValue
        }
    }
}

enum API {
    static var apiKey: String {
        do {
            return try Configuration.value(for: "API_KEY")
        } catch {
            fatalError("API_KEY not set in Info.plist")
        }
    }
}
