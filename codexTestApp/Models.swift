import Foundation

struct Flashcard: Identifiable {
    let id = UUID()
    let spanish: String
    let english: String
}

struct Deck {
    var cards: [Flashcard]

    /// Full list of available flashcards.
    static let allCards: [Flashcard] = [
        Flashcard(spanish: "hola", english: "hello"),
        Flashcard(spanish: "adios", english: "goodbye"),
        Flashcard(spanish: "gracias", english: "thank you"),
        Flashcard(spanish: "por favor", english: "please"),
        Flashcard(spanish: "si", english: "yes"),
            Flashcard(spanish: "no", english: "no"),
            Flashcard(spanish: "amigo", english: "friend"),
            Flashcard(spanish: "familia", english: "family"),
            Flashcard(spanish: "comida", english: "food"),
            Flashcard(spanish: "agua", english: "water"),
            Flashcard(spanish: "perro", english: "dog"),
            Flashcard(spanish: "gato", english: "cat"),
            Flashcard(spanish: "casa", english: "house"),
            Flashcard(spanish: "escuela", english: "school"),
            Flashcard(spanish: "libro", english: "book"),
            Flashcard(spanish: "coche", english: "car"),
            Flashcard(spanish: "rapido", english: "fast"),
            Flashcard(spanish: "lento", english: "slow"),
            Flashcard(spanish: "pequeno", english: "small"),
            Flashcard(spanish: "grande", english: "big"),
            Flashcard(spanish: "dia", english: "day"),
            Flashcard(spanish: "noche", english: "night"),
            Flashcard(spanish: "rojo", english: "red"),
            Flashcard(spanish: "verde", english: "green"),
            Flashcard(spanish: "azul", english: "blue"),
            Flashcard(spanish: "feliz", english: "happy"),
            Flashcard(spanish: "triste", english: "sad"),
            Flashcard(spanish: "trabajo", english: "work"),
            Flashcard(spanish: "tiempo", english: "time"),
            Flashcard(spanish: "dinero", english: "money"),
            Flashcard(spanish: "playa", english: "beach"),
            Flashcard(spanish: "montana", english: "mountain"),
            Flashcard(spanish: "ciudad", english: "city"),
            Flashcard(spanish: "campo", english: "countryside"),
            Flashcard(spanish: "verano", english: "summer"),
            Flashcard(spanish: "invierno", english: "winter"),
            Flashcard(spanish: "hoy", english: "today"),
            Flashcard(spanish: "manana", english: "tomorrow"),
        Flashcard(spanish: "izquierda", english: "left"),
        Flashcard(spanish: "derecha", english: "right")
        ]

    /// Create a deck with a random subset of the available cards.
    static func randomDeck(size: Int = 20) -> Deck {
        let shuffled = allCards.shuffled()
        let clamped = max(1, min(size, allCards.count))
        let selected = Array(shuffled.prefix(clamped))
        return Deck(cards: selected)
    }
}
