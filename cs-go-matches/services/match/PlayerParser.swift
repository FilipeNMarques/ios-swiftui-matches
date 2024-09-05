//
//  PlayerParser.swift
//  cs-go-matches
//
//  Created by Filipe Marques on 05/09/24.
//

import Foundation

struct PlayerParser {
    static func parse(json: [String: Any], teamId: Int) -> PlayerModel? {
        guard
            let id = json["id"] as? Int,
            let name = json["name"] as? String
        else {
            print("Failed to parse basic player info")
            return nil
        }

        let firstName = json["first_name"] as? String
        let imageUrl = json["image_url"] as? String

        return PlayerModel(
            id: id,
            name: name,
            firstName: firstName,
            imageUrl: imageUrl,
            teamId: teamId
        )
    }
}
