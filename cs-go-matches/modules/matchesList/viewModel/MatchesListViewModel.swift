//
//  MatchesListViewModel.swift
//  cs-go-matches
//
//  Created by Filipe Marques on 03/09/24.
//

import SwiftUI
import Observation

class MatchesListViewModel: ObservableObject {
    @Published var matches: [MatchListModel] = []
    @Published var isLoading = false

    private let matchService: MatchServiceProtocol

    init(matchService: MatchServiceProtocol = MatchService()) {
        self.matchService = matchService
    }

    @MainActor
    func fetchMatches() async {
        isLoading = true
        do {
            matches = try await matchService.fetchMatches()
        } catch {
            print("Error fetching matches: \(error)")
        }
        isLoading = false
    }
}
