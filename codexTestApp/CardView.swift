import SwiftUI

struct CardView: View {
    var card: Flashcard
    var onRemoval: () -> Void

    @State private var flipped = false
    @State private var offset: CGSize = .zero

    var body: some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(radius: 5)
                Text(card.spanish)
                    .font(.largeTitle)
                    .foregroundColor(.black)
            }
            .opacity(flipped ? 0 : 1)
            .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x:0, y:1, z:0))

            Group {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(radius: 5)
                Text(card.english)
                    .font(.largeTitle)
                    .foregroundColor(.black)
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
                        withAnimation {
                            offset.width = value.translation.width > 0 ? 1000 : -1000
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            offset = .zero
                            flipped = false
                            onRemoval()
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
    CardView(card: Flashcard(spanish: "hola", english: "hello")) {}
}
