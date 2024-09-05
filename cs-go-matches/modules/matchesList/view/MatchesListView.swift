//
//  MatchesListView.swift
//  cs-go-matches
//
//  Created by Filipe Marques on 03/09/24.
//

import SwiftUI

struct MatchesListView: View {
    @StateObject private var viewModel = MatchesListViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.matches) { match in
                            NavigationLink(value: match.toMatchDetailModel()) {
                                MatchRowView(match: match)
                            }
                        }
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)
                .navigationTitle("Partidas")
                .toolbarTitleDisplayMode(.large)
                .navigationDestination(for: MatchDetailModel.self) { matchDetail in
                    MatchDetailView()
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(MatchDetailViewModel(matchInfo: matchDetail))
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                CustomBackButton()
                            }
                        }
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
        }
        .task {
            await viewModel.fetchMatches()
        }
        .refreshable {
            await viewModel.fetchMatches()
        }
        .preferredColorScheme(.dark)
    }
}

extension MatchListModel {
    func toMatchDetailModel() -> MatchDetailModel {
        return MatchDetailModel(
            id: self.id,
            leagueName: self.league.name,
            serieName: self.serie.name,
            opponents: self.opponents.map {
                OpponentModel(
                    id: $0.id,
                    name: $0.name,
                    imageUrl: $0.imageUrl
                )
            },
            beginAt: self.beginAt
        )
    }
}

#Preview {
    MatchesListView()
}
