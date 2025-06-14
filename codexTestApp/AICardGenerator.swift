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
    private let model: SystemLanguageModel
    private let session: LanguageModelSession

    init() {
        let systemModel = SystemLanguageModel.default
        precondition(systemModel.isAvailable,
                     "Foundation Model not available—needs Apple Intelligence and compatible device")
        self.model = systemModel
        self.session = LanguageModelSession(model: systemModel)
    }

    func generateCards(count: Int) async throws -> [Flashcard] {
        let prompt = Prompt("Generate \(count) Spanish English flashcards as short words or phrases.")
        let result: [AICard] = try await session.respond(to: prompt, generating: [AICard].self)
        return result.map { Flashcard(spanish: $0.spanish, english: $0.english) }
    }

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
