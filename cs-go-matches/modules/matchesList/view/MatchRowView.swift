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
                Text(match.league.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(match.status.displayText)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(match.status.color)
                    .foregroundColor(.white)
                    .cornerRadius(4)
            }

            HStack(spacing: 20) {
                TeamColumnView(team: match.opponents[safe: 0])
                Text("VS")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                TeamColumnView(team: match.opponents[safe: 1])
            }

            if let beginAt = match.beginAt {
                Text(beginAt, style: .relative)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(20)
        .shadow(radius: 5)
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

extension String {
    var displayText: String {
        switch self {
        case "running": return "AGORA"
        case "not_started": return "Em breve"
        case "finished": return "Finalizada"
        case "canceled": return "Cancelada"
        case "postponed": return "Adiada"
        default: return "Desconhecido"
        }
    }

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

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct MatchRowView_Previews: PreviewProvider {
    static var previews: some View {
        MatchRowView(match: MatchListModel(
            id: 1,
            name: "Sample Match",
            status: "running",
            beginAt: Date(),
            opponents: [
                MatchListModel.Team(id: 1, name: "Reveal", imageUrl: "https://cdn.pandascore.co/images/team/image/132551/153px_reveal_allmode.png"),
                MatchListModel.Team(id: 2, name: "mYinsanity", imageUrl: "https://cdn.pandascore.co/images/team/image/127183/m_yinsanitylogo_square.png")
            ],
            league: MatchListModel.League(name: "Sample League")
        ))
        .previewLayout(.sizeThatFits)
    }
}
