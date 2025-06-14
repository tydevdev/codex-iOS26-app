import Foundation

/// Representation of a generated card.  The previous implementation relied on
/// the experimental `FoundationModels` framework and its macros.  Those macros
/// caused build failures in environments where the framework is unavailable.
/// To keep the project compiling on all platforms the model has been replaced
/// by a simple Codable type.
struct AICard: Codable {
    let spanish: String
    let english: String
}

/// Simple generator that returns random cards.  This acts as a stand‑in for the
/// Foundation models based implementation which isn't available in this
/// environment.
actor AICardGenerator {
    func generateCards(count: Int) async throws -> [Flashcard] {
        Deck.randomDeck(size: count).cards
    }

    func streamCards(count: Int) -> AsyncThrowingStream<[Flashcard], Error> {
        let cards = Deck.randomDeck(size: count).cards
        return AsyncThrowingStream { continuation in
            continuation.yield(cards)
            continuation.finish()
        }
    }
}
