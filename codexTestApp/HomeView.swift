import SwiftUI

struct HomeView: View {
    @State private var deck: Deck = Deck.randomDeck()
    @State private var showDeck = false

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Spanish Flashcards")
                    .font(.largeTitle.bold())
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
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [.blue.opacity(0.4), .purple.opacity(0.6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
        }
    }
}

#Preview {
    HomeView()
}
