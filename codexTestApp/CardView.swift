import SwiftUI

struct CardView: View {
    var card: Flashcard
    /// Callback when the card is swiped away. `true` means the user knew the
    /// word (swiped right) and `false` means they did not (swiped left).
    var onRemoval: (Bool) -> Void

    @State private var flipped = false
    @State private var offset: CGSize = .zero

    var body: some View {
        ZStack {
            // Spanish side
            Group {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .background(
                        LinearGradient(
                            colors: [.blue.opacity(0.6), .purple.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 5)
                Text(card.spanish)
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
            }
            .opacity(flipped ? 0 : 1)
            .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x:0, y:1, z:0))

            // English side
            Group {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .background(
                        LinearGradient(
                            colors: [.purple.opacity(0.6), .blue.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 5)
                Text(card.english)
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
            }
            .opacity(flipped ? 1 : 0)
            // Rotate the English side an additional 180° when flipped so it reads correctly
            .rotation3DEffect(
                .degrees(flipped ? 180 : -180),
                axis: (x: 0, y: 1, z: 0)
            )
        }
        .frame(width: 300, height: 200)
        .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x:0, y:1, z:0))
        .animation(.easeInOut, value: flipped)
        .offset(offset)
        .gesture(
            DragGesture()
                .onChanged { offset = $0.translation }
                .onEnded { value in
                    if abs(value.translation.width) > 100 {
                        let knewWord = value.translation.width > 0
                        withAnimation {
                            offset.width = knewWord ? 1000 : -1000
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            offset = .zero
                            flipped = false
                            onRemoval(knewWord)
                        }
                    } else {
                        withAnimation { offset = .zero }
                    }
                }
        )
        .onTapGesture { flipped.toggle() }
    }
}

#Preview {
    CardView(card: Flashcard(spanish: "hola", english: "hello")) { _ in }
}
