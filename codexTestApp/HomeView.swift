import SwiftUI

struct HomeView: View {
    @State private var deck: Deck = Deck.randomDeck()
    @State private var showDeck = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Spanish Flashcards")
                    .font(.largeTitle)
                    .padding()

                Button("Remake Deck") {
                    deck = Deck.randomDeck()
                }
                .buttonStyle(.borderedProminent)

                NavigationLink(destination: DeckView(deck: deck), isActive: $showDeck) {
                    EmptyView()
                }

                Button("Start") {
                    showDeck = true
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

#Preview {
    HomeView()
}
