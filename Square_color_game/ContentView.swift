////
////  ContentView.swift
////  Square_color_game
////
////  Created by COBSCCOMP24.2P-019 on 2026-01-10.
////
//import SwiftUI
//
//enum GameColor: CaseIterable, Hashable {
//    case red, blue, green, yellow, orange, purple, pink, cyan, brown, gray
//
//    var name: String {
//        switch self {
//        case .red: return "RED"
//        case .blue: return "BLUE"
//        case .green: return "GREEN"
//        case .yellow: return "YELLOW"
//        case .orange: return "ORANGE"
//        case .purple: return "PURPLE"
//        case .pink: return "PINK"
//        case .cyan: return "CYAN"
//        case .brown: return "BROWN"
//        case .gray: return "GRAY"
//        }
//    }
//
//    var swiftUIColor: Color {
//        switch self {
//        case .red: return .red
//        case .blue: return .blue
//        case .green: return .green
//        case .yellow: return .yellow
//        case .orange: return .orange
//        case .purple: return .purple
//        case .pink: return .pink
//        case .cyan: return .cyan
//        case .brown: return .brown
//        case .gray: return .gray
//        }
//    }
//}
//
//
//enum Difficulty {
//    case easy, medium, hard
//    
//    var gridSize: Int {
//        switch self {
//        case .easy: return 3
//        case .medium: return 5
//        case .hard: return 7
//        }
//    }
//}
//
//struct ContentView: View {
//    
//    @State private var selectedDifficulty: Difficulty? = nil
//    @State private var targetColor = GameColor.allCases.randomElement()!
//    @State private var options: [GameColor] = []
//    @State private var score = 0
//    @State private var showError = false
//    @State private var errorMessage = ""
//    @State private var gameOver = false
//    @State private var tappedIndices: Set<Int> = []
//
//    var body: some View {
//        VStack(spacing: 30) {
//            if selectedDifficulty == nil {
//                // Difficulty selection screen
//                Text("Select Difficulty")
//                    .font(.largeTitle)
//                    .bold()
//                
//                VStack(spacing: 20) {
//                    Button("Easy") { startGame(.easy) }
//                        .difficultyButtonStyle()
//                    Button("Medium") { startGame(.medium) }
//                        .difficultyButtonStyle()
//                    Button("Hard") { startGame(.hard) }
//                        .difficultyButtonStyle()
//                }
//                .padding(.horizontal, 40) // optional padding so they don't touch screen edgesdifficultyButtonStyle
//
//                Spacer()
//            } else {
//                // Game UI goes here
//                Text("Match the Color")
//                    .font(.largeTitle)
//                    .bold()
//                
//                Text("Score: \(score)")
//                    .font(.title2)
//                
//                if !gameOver {
//                    HStack(spacing: 15) {
//                        Rectangle()
//                            .fill(targetColor.swiftUIColor)
//                            .frame(width: 50, height: 50)
//                            .cornerRadius(8)
//                            .shadow(radius: 2)
//                        
//                        Text(targetColor.name)
//                            .font(.title)
//                            .bold()
//                    }
//                }
//                
//                if !gameOver, let difficulty = selectedDifficulty {
//                    let gridSize = difficulty.gridSize
//                    
//                    GeometryReader { geometry in
//                        let spacing: CGFloat = 10
//                        let totalSpacing = spacing * CGFloat(gridSize - 1)
//                        let squareWidth = (geometry.size.width - totalSpacing - 20) / CGFloat(gridSize)
//                        // 20 is optional padding adjustment
//
//                        let columns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: gridSize)
//
//                        LazyVGrid(columns: columns, spacing: spacing) {
//                            ForEach(options.indices, id: \.self) { index in
//                                let color = options[index]
//                                
//                                Button {
//                                    checkAnswer(at: index)
//                                } label: {
//                                    Rectangle()
//                                        .fill(color.swiftUIColor)
//                                        .opacity(tappedIndices.contains(index) ? 0.3 : 1)
//                                        .frame(width: squareWidth, height: squareWidth) // square!
//                                        .cornerRadius(8)
//                                }
//                            }
//                        }
//                        .padding()
//                    }
//                    .frame(height: CGFloat(difficulty.gridSize) * 60) // approximate height for GeometryReader
//                }
//
//                
//                if showError {
//                    Text(errorMessage)
//                        .foregroundColor(.red)
//                        .font(.headline)
//                }
//                
//                if gameOver {
//                    Button("Restart Game") {
//                        restartGame()
//                    }
//                    .padding()
//                }
//            }
//        }
//
//        .padding()
//    }
//    
//    // MARK: - Game Logic
//    
//    func startGame(_ difficulty: Difficulty) {
//        selectedDifficulty = difficulty
//        resetRound()
//    }
//    
//    func resetRound() {
//        tappedIndices.removeAll()
//        showError = false
//        gameOver = false
//        score = 0
//        newRound()
//    }
//    
//    func newRound() {
//        guard let difficulty = selectedDifficulty else { return }
//        
//        let colors = availableColors(for: difficulty)
//        
//        targetColor = colors.randomElement()!
//        
//        let totalSquares = difficulty.gridSize * difficulty.gridSize
//        
//        options = (0..<totalSquares).map { _ in
//            colors.randomElement()!
//        }
//        
//        // Ensure at least one correct answer
//        options[Int.random(in: 0..<totalSquares)] = targetColor
//    }
//
//    func checkAnswer(at index: Int) {
//        let selected = options[index]
//        
//        if selected == targetColor {
//            tappedIndices.insert(index)
//            score += 1
//            
//            // Check if all target colors are tapped
//            let remaining = options.indices.filter { options[$0] == targetColor && !tappedIndices.contains($0) }
//            if remaining.isEmpty {
//                tappedIndices.removeAll()
//                newRound()
//            }
//        } else {
//            errorMessage = "You Lost!"
//            showError = true
//            gameOver = true
//        }
//    }
//    
//    func availableColors(for difficulty: Difficulty) -> [GameColor] {
//        switch difficulty {
//        case .easy:
//            return [.red, .blue, .green, .yellow]
//        case .medium:
//            return [.red, .blue, .green, .yellow, .orange, .purple]
//        case .hard:
//            return [.red, .blue, .green, .yellow, .orange, .purple, .pink, .cyan]
//        }
//    }
//
//    
//    func restartGame() {
//        tappedIndices.removeAll()
//        score = 0
//        showError = false
//        gameOver = false
//        selectedDifficulty = nil
//    }
//}
//
//// MARK: - Button style helper
//extension View {
//    func difficultyButtonStyle() -> some View {
//        self
//            .font(.title2)
//            .padding()
//            .frame(maxWidth: .infinity)
//            .background(Color.blue.opacity(0.7))
//            .foregroundColor(.white)
//            .cornerRadius(12)
//            .shadow(radius: 3)
//    }
//}
//
//#Preview {
//    ContentView()
//}

import SwiftUI

struct ContentView: View { enum Step { case start, name, level, game }

@State private var step: Step = .start
@State private var playerName: String = ""
@State private var selectedLevel: String? = nil
@State private var resetGame: Bool = false
@State private var resetMessage: String = ""
@State private var toastMessage: String = ""

var body: some View {
    ZStack {
        AnimatedGradientBackground()

        VStack(spacing: 20) {

            // TOAST
            if !toastMessage.isEmpty {
                ToastView(message: toastMessage)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }

            // START
            if step == .start {
                VStack(spacing: 20) {
                    Text("🟩🟦 💥 Color Blast 💣 🟥🟨")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    PrimaryButton(title: "Start Game") {
                        step = .name
                    }
                }
            }

            // NAME
            if step == .name {
                VStack(spacing: 20) {
                    Text("Enter Your Name")
                        .font(.title2)
                        .fontWeight(.bold)

                    TextField("Your name...", text: $playerName)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .frame(width: 220)

                    PrimaryButton(title: "Next") {
                        if playerName.trimmingCharacters(in: .whitespaces).isEmpty {
                            showToast("⚠️ Please enter your name!")
                        } else {
                            step = .level
                        }
                    }
                }
            }

            // LEVEL
            if step == .level {
                VStack(spacing: 20) {
                    Text("Welcome, \(playerName)!")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("Select Difficulty:")
                        .font(.headline)

                    LevelSelectorView { level in
                        selectedLevel = level
                        step = .game
                    }
                }
            }

            // GAME
            if step == .game, let level = selectedLevel {
                VStack(spacing: 15) {
                    Text("Player: \(playerName)")
                        .font(.headline)

                    if !resetMessage.isEmpty {
                        Text(resetMessage)
                            .foregroundColor(.yellow)
                            .fontWeight(.bold)
                    }

                    GameBoardView(level: level, resetTrigger: $resetGame)

                    HStack(spacing: 20) {
                        GlossyButton(title: "🔄 Restart", colors: [.purple, .pink]) {
                            handleRestart()
                        }

                        GlossyButton(title: "❌ Quit", colors: [.red, .orange]) {
                            handleQuit()
                        }
                    }
                }
            }
        }
        .padding()
    }
}

// MARK: - Functions

private func showToast(_ message: String) {
    toastMessage = message
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        withAnimation {
            toastMessage = ""
        }
    }
}

private func handleRestart() {
    resetGame = true
    resetMessage = "🔄 Game Reset!"
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        resetMessage = ""
        resetGame = false
    }
}

private func handleQuit() {
    step = .start
    playerName = ""
    selectedLevel = nil
    resetMessage = ""
}
}
