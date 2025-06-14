import Foundation

#if canImport(FoundationModels)
import FoundationModels

/// Representation of a flashcard returned from the Foundation model.
@Generable
struct AICard: Codable {
    @Guide("Spanish word or phrase")
    var spanish: String

    @Guide("English translation of the word or phrase")
    var english: String
}

/// Generator that uses `FoundationModels` to create flashcards based on a
/// textual prompt. Falls back to a simple error when the framework isn't
/// available.
actor AICardGenerator {
    private let model: SystemLanguageModel
    private let session: LanguageModelSession

    init() {
        let systemModel = SystemLanguageModel.default
        precondition(systemModel.isAvailable,
                     "Foundation model not available—needs Apple Intelligence and compatible device")
        self.model = systemModel
        self.session = LanguageModelSession(model: systemModel)
    }

    /// Generate an entire deck of cards at once.
    func generateCards(count: Int) async throws -> [Flashcard] {
        let prompt = Prompt("Generate \(count) Spanish English flashcards as short words or phrases.")
        let response = try await session.respond(to: prompt, generating: [AICard].self)
        let cards = response.content
        return cards.map { Flashcard(spanish: $0.spanish, english: $0.english) }
    }

    /// Stream cards as they are produced so the UI can update incrementally.
    func streamCards(count: Int) -> AsyncThrowingStream<[Flashcard], Error> {
        let prompt = Prompt("Generate \(count) Spanish English flashcards as short words or phrases.")
        let stream = session.streamResponse(to: prompt, generating: [AICard].self)
        return AsyncThrowingStream { continuation in
            Task {
                do {
                    for try await partial in stream {
                        let cards = partial.content.map { Flashcard(spanish: $0.spanish, english: $0.english) }
                        continuation.yield(cards)
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
#else
/// Fallback implementation used when `FoundationModels` isn't available.
struct AICard: Codable {
    let spanish: String
    let english: String
}

actor AICardGenerator {
    func generateCards(count: Int) async throws -> [Flashcard] {
        throw NSError(domain: "AICardGenerator", code: 1,
                      userInfo: [NSLocalizedDescriptionKey:
                        "FoundationModels framework not available"])
    }

    func streamCards(count: Int) -> AsyncThrowingStream<[Flashcard], Error> {
        AsyncThrowingStream { continuation in
            continuation.finish(throwing: NSError(
                domain: "AICardGenerator", code: 1,
                userInfo: [NSLocalizedDescriptionKey: "FoundationModels framework not available"]
            ))
        }
    }
}
#endif
