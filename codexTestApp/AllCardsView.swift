import SwiftUI

struct AllCardsView: View {
    var body: some View {
        List(Deck.allCards) { card in
            HStack {
                Text(card.spanish)
                    .font(.headline)
                Spacer()
                Text(card.english)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("All Cards")
    }
}

#Preview {
    AllCardsView()
}
