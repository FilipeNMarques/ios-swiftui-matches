//
//  MatchesListViewModel.swift
//  cs-go-matches
//
//  Created by Filipe Marques on 03/09/24.
//

import SwiftUI

@Observable
class MatchesListViewModel: ObservableObject {
    var matches: [MatchListModel] = []
    var isLoading = false
    var error: AppError?

    private let matchService: MatchServiceProtocol

    init(matchService: MatchServiceProtocol = MatchService()) {
        self.matchService = matchService
    }

    @MainActor
    func fetchMatches() async {
        isLoading = true
        do {
            matches = try await matchService.fetchMatches()
        } catch let error as AppError {
            self.error = error
            debugPrint("App error: ", error)
        } catch {
            self.error = .unknown(error.localizedDescription
            debugPrint("unknown error: ", error))
        }
        isLoading = false
    }
}
