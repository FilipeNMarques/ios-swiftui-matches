//
//  MatchDetailViewModel.swift
//  cs-go-matches
//
//  Created by Filipe Marques on 05/09/24.
//

import Foundation

@Observable
class MatchDetailViewModel: ObservableObject {
    let matchInfo: MatchDetailModel
    var playersByTeam: [Int: [PlayerModel]] = [:]
    var isLoading = false
    var error: AppError?

    private let matchService: MatchServiceProtocol

    init(matchInfo: MatchDetailModel, matchService: MatchServiceProtocol = MatchService()) {
        self.matchInfo = matchInfo
        self.matchService = matchService
    }

    @MainActor
    func fetchMatchDetails() async {
        isLoading = true
        do {
            let players = try await matchService.fetchMatchDetails(matchId: matchInfo.id)
            playersByTeam = Dictionary(grouping: players, by: { $0.teamId })
        } catch let error as AppError {
            self.error = error
            print("App error: ", error)
        } catch {
            self.error = .unknown(error.localizedDescription)
            print("Unknown error: ", error)
        }
        isLoading = false
    }
}
