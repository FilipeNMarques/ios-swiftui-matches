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
                            NavigationLink(value: match) {
                                MatchRowView(match: match)
                            }
                        }
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)
                .navigationTitle("Partidas")
                .navigationDestination(for: MatchListModel.self) { match in
                    MatchDetailView(match: match)
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

struct MatchDetailView: View {
    let match: MatchListModel

    var body: some View {
        VStack(spacing: 20) {
            Text(match.name)
                .font(.title)

            Text("Status: \(match.status)")
                .font(.headline)

            if let beginAt = match.beginAt {
                Text("Início: \(beginAt.formatted())")
            }

            Text("Liga: \(match.league.name)")

            ForEach(match.opponents, id: \.id) { team in
                VStack {
                    if let imageUrlString = team.imageUrl, let imageUrl = URL(string: imageUrlString) {
                        AsyncImage(url: imageUrl) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    Text(team.name)
                        .font(.headline)
                }
            }
        }
        .padding()
    }
}

#Preview {
    MatchesListView()
}
