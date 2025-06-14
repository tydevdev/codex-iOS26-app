import Foundation

#if canImport(FoundationModels)
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
#else
/// Fallback implementation used when the FoundationModels framework isn't
/// available (e.g. when building on Linux). This simply throws an error to
/// indicate that AI card generation isn't supported.
struct AICardGenerator {
    func generateCards(count: Int) async throws -> [Flashcard] {
        throw NSError(domain: "AICardGenerator", code: 1,
                      userInfo: [NSLocalizedDescriptionKey:
                        "FoundationModels framework not available"])
    }
}
#endif
