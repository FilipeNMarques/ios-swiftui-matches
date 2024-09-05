//
//  MatchDetailView.swift
//  cs-go-matches
//
//  Created by Filipe Marques on 05/09/24.
//

import SwiftUI

struct MatchDetailView: View {
    @EnvironmentObject private var viewModel: MatchDetailViewModel

    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()

            VStack(spacing: 30) {
                matchInfoHeader
                teamsSection
                if let beginAt = viewModel.matchInfo.beginAt {
                    Text(formatDate(beginAt))
                        .font(.caption)
                }
                PlayersSection(viewModel: viewModel)
                Spacer()
            }
        }
        .task {
            await viewModel.fetchMatchDetails()
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }

    private var matchInfoHeader: some View {
        HStack(spacing: 8) {
            Text(viewModel.matchInfo.leagueName)
                .font(.title2)

            Text(viewModel.matchInfo.serieName)
                .font(.title2)
        }
    }

    private var teamsSection: some View {
        HStack(spacing: 40) {
            TeamView(team: viewModel.matchInfo.opponents[0])

            Text("vs")

            TeamView(team: viewModel.matchInfo.opponents[1])
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.string(from: date)
    }
}

struct PlayersSection: View {
    @ObservedObject var viewModel: MatchDetailViewModel

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            if viewModel.matchInfo.opponents.count >= 2 {
                PlayerColumnView(opponent: viewModel.matchInfo.opponents[0], players: viewModel.playersByTeam[viewModel.matchInfo.opponents[0].id] ?? [], isLeftColumn: true)
                PlayerColumnView(opponent: viewModel.matchInfo.opponents[1], players: viewModel.playersByTeam[viewModel.matchInfo.opponents[1].id] ?? [], isLeftColumn: false)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct PlayerColumnView: View {
    let opponent: OpponentModel
    let players: [PlayerModel]
    let isLeftColumn: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            ForEach(players, id: \.id) { player in
                if isLeftColumn {
                    PlayerRowViewLeft(player: player)
                } else {
                    PlayerRowViewRight(player: player)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .cornerRadius(8)
    }
}

struct PlayerRowViewLeft: View {
    let player: PlayerModel

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .trailing) {
                Text(player.name)
                    .lineLimit(1)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .trailing)

                Text(player.firstName ?? "")
                    .lineLimit(1)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)

            AsyncImage(url: URL(string: player.imageUrl ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray
            }
            .frame(width: 65, height: 65)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .frame(height: 65)
        .background(Color.backgroundSecondary.clipShape(RoundedCorner(
            radius: 8,
            corners: [.topRight, .bottomRight]
        )))
    }
}

struct PlayerRowViewRight: View {
    let player: PlayerModel

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: player.imageUrl ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray
            }
            .frame(width: 65, height: 65)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .trailing) {
                Text(player.name)
                    .lineLimit(1)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(player.firstName ?? "")
                    .lineLimit(1)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 65)
        .background(Color.backgroundSecondary.clipShape(RoundedCorner(
            radius: 8,
            corners: [.topLeft, .bottomLeft]
        )))
    }
}

struct TeamView: View {
    let team: OpponentModel

    var body: some View {
        VStack {
            if let imageUrlString = team.imageUrl, let imageUrl = URL(string: imageUrlString) {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                } placeholder: {
                    ProgressView()
                }
            }

            Text(team.name)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    NavigationView {
        MatchDetailView()
            .environmentObject(MatchDetailViewModel.mockDataForPreview(matchInfo: MatchDetailModel(
                id: 1,
                leagueName: "ESL Pro League",
                serieName: "Season 15",
                opponents: [
                    OpponentModel(id: 3210, name: "G2", imageUrl: "https://cdn.pandascore.co/images/team/image/3210/5995.png"),
                    OpponentModel(id: 3318, name: "3DMAX", imageUrl: "https://cdn.pandascore.co/images/team/image/3318/3DMAX.png")
                ],
                beginAt: Date()
            )))
    }
    .preferredColorScheme(.dark)
}

extension MatchDetailViewModel {
    static func mockDataForPreview(matchInfo: MatchDetailModel) -> MatchDetailViewModel {
        let viewModel = MatchDetailViewModel(matchInfo: matchInfo)
        viewModel.playersByTeam = [
            3210: [
                PlayerModel(id: 17502, name: "Snaxxxxxxxxx", firstName: "Janusz", imageUrl: "https://cdn.pandascore.co/images/player/image/17502/600px_snax_moche_xl_esports_2019.png", teamId: 3210),
                PlayerModel(id: 17522, name: "NiKo", firstName: "Nikola", imageUrl: "https://cdn.pandascore.co/images/player/image/17522/600px_ni_ko___iem_beijing_2019.png", teamId: 3210),
                PlayerModel(id: 17958, name: "huNter-", firstName: "Nemanja", imageUrl: "https://cdn.pandascore.co/images/player/image/17958/900px_hu_nter__epl_s10_finals_odense_2019.png", teamId: 3210),
                PlayerModel(id: 21433, name: "malbsMd", firstName: "Mario", imageUrl: "https://cdn.pandascore.co/images/player/image/21433/900px_malbs_md_epl10.png", teamId: 3210),
                PlayerModel(id: 25998, name: "m0NESY", firstName: "Ilya", imageUrl: "https://cdn.pandascore.co/images/player/image/25998/enrp_n72zs_bm.png", teamId: 3210)
            ],
            3318: [
                PlayerModel(id: 18297, name: "Maka", firstName: "Bryan", imageUrl: "https://cdn.pandascore.co/images/player/image/18297/600px_maka_at_esl_championnat_national_winter_2017.png", teamId: 3318),
                PlayerModel(id: 20212, name: "Lucky", firstName: "Lucas", imageUrl: "https://cdn.pandascore.co/images/player/image/20212/600px_lucky_esl_pro_league_season_9.png", teamId: 3318),
                PlayerModel(id: 29153, name: "Djoko", firstName: "Thomas", imageUrl: "https://cdn.pandascore.co/images/player/image/29153/1105884.1601040178_t.png", teamId: 3318),
                PlayerModel(id: 29805, name: "Ex3rcice", firstName: "Pierre", imageUrl: nil, teamId: 3318),
                PlayerModel(id: 32624, name: "Graviti", firstName: "Filip", imageUrl: nil, teamId: 3318)
            ]
        ]
        return viewModel
    }
}
