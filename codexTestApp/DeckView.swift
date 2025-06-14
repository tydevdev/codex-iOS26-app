import SwiftUI

struct DeckView: View {
    var deck: Deck
    @State private var index: Int = 0
    @State private var correctCount: Int = 0
    @State private var wrongCount: Int = 0

    var body: some View {
        VStack(spacing: 20) {
            if index < deck.cards.count {
                Text("Card \(index + 1) of \(deck.cards.count)")
                    .font(.headline)

                ProgressView(value: Double(index), total: Double(deck.cards.count))
                    .padding(.horizontal)

                CardView(card: deck.cards[index]) { knew in
                    if knew {
                        correctCount += 1
                    } else {
                        wrongCount += 1
                    }
                    withAnimation { index += 1 }
                }
            } else {
                VStack(spacing: 12) {
                    Text("Finished!")
                        .font(.largeTitle)
                    Text("Correct: \(correctCount)")
                    Text("Incorrect: \(wrongCount)")
                    Button("Restart") {
                        index = 0
                        correctCount = 0
                        wrongCount = 0
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .navigationTitle("Cards")
    }
}

#Preview {
    DeckView(deck: Deck.randomDeck())
}
