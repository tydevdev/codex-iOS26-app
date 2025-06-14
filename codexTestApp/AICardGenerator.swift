import Foundation
import FoundationModels

@Generable
struct AICard: Codable {
    @Guide("Spanish word or phrase")
    var spanish: String

    @Guide("English translation of the word or phrase")
    var english: String
}

actor AICardGenerator {
    private let session = LanguageModelSession()

    init() {
        precondition(SystemLanguageModel.default.isAvailable, "Foundation Model not available—needs Apple Intelligence and compatible device")
    }

    func generateCards(count: Int) async throws -> [Flashcard] {
        let prompt = "Generate \(count) Spanish English flashcards as short words or phrases."
        let aiCards: [AICard] = try await session.respond(to: prompt, generating: [AICard].self)
        return aiCards.map { Flashcard(spanish: $0.spanish, english: $0.english) }
    }
}
