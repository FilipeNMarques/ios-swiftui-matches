//
//  Collections.swift
//  cs-go-matches
//
//  Created by Filipe Marques on 04/09/24.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
