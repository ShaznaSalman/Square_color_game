import SwiftUI

struct GameCard: Identifiable {
    let id: Int
    var color: Color
    var isFlipped: Bool
    var isMatched: Bool
    var isBomb: Bool
}

struct GameBoardView: View {
    let level: String
    @Binding var resetTrigger: Bool

    @State private var cards: [GameCard] = []
    @State private var flippedIndices: [Int] = []
    @State private var score: Int = 0
    @State private var maxScore: Int = 0
    @State private var bombMessage: String = ""
    @State private var isAnimating: Bool = false

    private var gridSize: Int {
        LEVELS[level] ?? 3
    }

    var body: some View {
        VStack(spacing: 10) {
            Text("Score: \(score) / \(maxScore)")
                .fontWeight(.bold)

            if !bombMessage.isEmpty {
                Text(bombMessage)
                    .foregroundColor(.red)
                    .font(.title3)
                    .fontWeight(.bold)
            }

            if score == maxScore && maxScore > 0 {
                Text("🎉 You Win! All pairs matched!")
                    .foregroundColor(.green)
                    .font(.headline)
            }

            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.fixed(60)),
                    count: gridSize
                ),
                spacing: 10
            ) {
                ForEach(cards.indices, id: \.self) { index in
                    CardView(card: cards[index])
                        .onTapGesture {
                            handleCardTap(index)
                        }
                }
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color.black.opacity(0.4))
        .cornerRadius(20)
        .onAppear { setupBoard() }
        .onChange(of: resetTrigger) { _ in
            setupBoard()
        }
    }

    // MARK: - Logic

    private func setupBoard() {
        guard let size = LEVELS[level] else { return }

        let total = size * size
        let pairs = total / 2

        score = 0
        maxScore = pairs
        bombMessage = ""
        flippedIndices = []

        var colors: [Color] = []
        for i in 0..<pairs {
            let color = COLORS[i % COLORS.count]
            colors.append(color)
            colors.append(color)
        }

        var tempCards: [GameCard] = colors.enumerated().map { idx, color in
            GameCard(
                id: idx,
                color: color,
                isFlipped: false,
                isMatched: false,
                isBomb: false
            )
        }

        if total % 2 != 0 {
            tempCards.append(
                GameCard(
                    id: tempCards.count,
                    color: .black,
                    isFlipped: false,
                    isMatched: false,
                    isBomb: true
                )
            )
        }

        tempCards.shuffle()
        cards = tempCards
    }

    private func handleCardTap(_ index: Int) {
        if isAnimating || flippedIndices.count == 2 { return }
        if cards[index].isFlipped || cards[index].isMatched { return }

        cards[index].isFlipped = true

        if cards[index].isBomb {
            triggerBomb()
            return
        }

        flippedIndices.append(index)

        if flippedIndices.count == 2 {
            let first = flippedIndices[0]
            let second = flippedIndices[1]

            if cards[first].color == cards[second].color {
                cards[first].isMatched = true
                cards[second].isMatched = true
                score += 1
                flippedIndices = []
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    cards[first].isFlipped = false
                    cards[second].isFlipped = false
                    flippedIndices = []
                }
            }
        }
    }

    private func triggerBomb() {
        isAnimating = true
        bombMessage = "💥 Oops! Bomb Shuffle!"
        score = 0

        for i in cards.indices {
            cards[i].isFlipped = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            var normalCards = cards.filter { !$0.isBomb }
            var bombCards = cards.filter { $0.isBomb }

            let shuffledColors = normalCards.map { $0.color }.shuffled()

            for i in normalCards.indices {
                normalCards[i].color = shuffledColors[i]
                normalCards[i].isFlipped = false
                normalCards[i].isMatched = false
            }
            for i in bombCards.indices {
                        bombCards[i].isFlipped = false
                        bombCards[i].isMatched = false
            }

            cards = (normalCards + bombCards).shuffled()
            flippedIndices = []
            bombMessage = ""
            isAnimating = false
        }
    }
}
