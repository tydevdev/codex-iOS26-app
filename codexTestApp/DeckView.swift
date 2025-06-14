import SwiftUI

struct DeckView: View {
    var deck: Deck
    @State private var index: Int = 0

    var body: some View {
        VStack {
            if index < deck.cards.count {
                CardView(card: deck.cards[index]) {
                    withAnimation { index += 1 }
                }
            } else {
                Text("Finished!")
                    .font(.largeTitle)
            }
        }
        .navigationTitle("Cards")
    }
}

#Preview {
    DeckView(deck: Deck.randomDeck())
}
