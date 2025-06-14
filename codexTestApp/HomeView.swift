import SwiftUI

struct HomeView: View {
    @State private var deckSize: Int = 10
    @State private var deck: Deck = Deck.randomDeck(size: 10)
    @State private var showDeck = false
    @State private var isGenerating = false

    private func generateAIDeck() async {
        isGenerating = true
        defer { isGenerating = false }
        do {
            let generator = AICardGenerator()
            let cards = try await generator.generateCards(count: deckSize)
            deck = Deck(cards: cards)
        } catch {
            print("Failed to generate cards: \(error)")
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Spanish Flashcards")
                        .font(.largeTitle.bold())
                        .padding(.top)

                    Text("Practice your vocabulary by swiping through cards. Select how many cards you'd like in this session and press Start.")
                        .multilineTextAlignment(.center)

                    Stepper("Deck size: \(deckSize)", value: $deckSize, in: 5...Deck.allCards.count, step: 5)
                        .padding(.horizontal)

                    Button("Generate Deck") {
                        deck = Deck.randomDeck(size: deckSize)
                    }
                    .buttonStyle(.borderedProminent)

                    if isGenerating {
                        ProgressView()
                    }

                    Button("Generate AI Deck") {
                        Task { await generateAIDeck() }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isGenerating)

                    NavigationLink(destination: DeckView(deck: deck), isActive: $showDeck) {
                        EmptyView()
                    }

                    Button("Start Practice") {
                        showDeck = true
                    }
                    .buttonStyle(.bordered)

                    NavigationLink("View All Cards", destination: AllCardsView())
                        .padding(.top, 10)

                    Spacer(minLength: 0)
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
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
