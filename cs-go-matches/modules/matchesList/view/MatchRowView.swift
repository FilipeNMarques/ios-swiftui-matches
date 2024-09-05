//
//  MatchRowView.swift
//  cs-go-matches
//
//  Created by Filipe Marques on 03/09/24.
//

import SwiftUI

struct MatchRowView: View {
    let match: MatchListModel

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Spacer()
                statusView
            }

            VStack(spacing: 12) {
                HStack(spacing: 20) {
                    TeamColumnView(team: match.opponents[safe: 0])
                    Text("VS")
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                    TeamColumnView(team: match.opponents[safe: 1])
                }

                Divider()
                    .frame(height: 1)
                    .background(Color.gray.opacity(0.5))
                    .padding(.horizontal, -16)

                HStack(alignment: .center) {
                    if let imageUrlString = match.league.imageUrl, let imageUrl = URL(string: imageUrlString) {
                        AsyncImage(url: imageUrl) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                        } placeholder: {
                            Color.gray
                                .frame(width: 20, height: 20)
                                .cornerRadius(20)
                        }
                    }

                    Text(match.league.name)
                        .font(.caption)
                        .foregroundColor(.white)
                        .lineLimit(1)

                    Text(match.serie.name)
                        .font(.caption)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

            }.padding()
        }
        .background(Color.backgroundSecondary)
        .cornerRadius(20)
        .shadow(radius: 5)
    }

    private var statusView: some View {
        Text(statusText)
            .font(.caption)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .background(statusColor.clipShape(RoundedCorner(
                radius: 20,
                corners: [.topRight, .bottomLeft]
            )))
    }

    private var statusText: String {
        if match.status == "running" {
            return "AGORA"
        } else if let beginAt = match.beginAt {
            return formatDate(beginAt)
        } else {
            return "Data desconhecida"
        }
    }

    private var statusColor: Color {
        match.status == "running" ? .accentRed : .gray
    }

    private func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")

        if calendar.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"

            return "Hoje, \(formatter.string(from: date))"
        } else if calendar.isDate(date, equalTo: Date(), toGranularity: .weekOfYear) {
            formatter.dateFormat = "E, HH:mm"
            let formattedString = formatter.string(from: date).capitalized

            return formattedString.replacingOccurrences(of: ".", with: "")
        } else {
            formatter.dateFormat = "dd.MM, HH:mm"

            return formatter.string(from: date)
        }
    }

    struct TeamColumnView: View {
        let team: MatchListModel.Team?

        var body: some View {
            VStack(spacing: 8) {
                if let team = team, let imageUrlString = team.imageUrl, let imageUrl = URL(string: imageUrlString) {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 60, height: 60)
                }

                Text(team?.name ?? "TBD")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.white)
            }
            .frame(width: 100)
        }
    }

}

extension String {
    var color: Color {
        switch self {
        case "running": return .accentRed
        case "not_started": return .blue
        case "finished": return .gray
        case "canceled", "postponed": return .red
        default: return .orange
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        // Match happening now
        MatchRowView(match: MatchListModel(
            id: 1,
            name: "Partida Atual",
            status: "running",
            beginAt: Date(),
            opponents: [
                MatchListModel.Team(id: 1, name: "Reveal", imageUrl: "https://cdn.pandascore.co/images/team/image/132551/153px_reveal_allmode.png"),
                MatchListModel.Team(id: 2, name: "mYinsanity", imageUrl: "https://cdn.pandascore.co/images/team/image/127183/m_yinsanitylogo_square.png")
            ],
            league: MatchListModel.League(name: "CCT Europe", imageUrl: "https://cdn.pandascore.co/images/league/image/5232/799px-cct_2024_europe_allmode-png"),
            serie: MatchListModel.Serie(name: "Series #11")
        ))

        // Match later today
        MatchRowView(match: MatchListModel(
            id: 2,
            name: "Partida Hoje",
            status: "not_started",
            beginAt: Calendar.current.date(byAdding: .hour, value: 3, to: Date()),
            opponents: [
                MatchListModel.Team(id: 3, name: "Space", imageUrl: "https://cdn.pandascore.co/images/team/image/133460/9t_k9_vn_ek_tfg_pcg_x8_sy9u_r.png"),
                MatchListModel.Team(id: 4, name: "Favbet", imageUrl: "https://cdn.pandascore.co/images/team/image/134964/285px_favbet_team_allmode.png")
            ],
            league: MatchListModel.League(name: "CCT Europe", imageUrl: "https://cdn.pandascore.co/images/league/image/5232/799px-cct_2024_europe_allmode-png"),
            serie: MatchListModel.Serie(name: "Series #11")
        ))

        // Match tomorrow
        MatchRowView(match: MatchListModel(
            id: 3,
            name: "Partida Amanhã",
            status: "not_started",
            beginAt: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            opponents: [
                MatchListModel.Team(id: 5, name: "Monte", imageUrl: "https://cdn.pandascore.co/images/team/image/131441/633px_monte_2022_allmode.png"),
                MatchListModel.Team(id: 6, name: "PARIVISION", imageUrl: "https://cdn.pandascore.co/images/team/image/133719/250px_parivision_allmode.png")
            ],
            league: MatchListModel.League(name: "CCT Europe", imageUrl: "https://cdn.pandascore.co/images/league/image/5232/799px-cct_2024_europe_allmode-png"),
            serie: MatchListModel.Serie(name: "Series #11")
        ))
    }
    .padding()
    .previewLayout(.sizeThatFits)
}
