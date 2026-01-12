//
//  ContentView.swift
//  Square_color_game
//
//  Created by COBSCCOMP24.2P-019 on 2026-01-10.
//
import SwiftUI

enum GameColor: CaseIterable, Hashable {
    case red, blue, green, yellow, orange, purple, pink, cyan, brown, gray

    var name: String {
        switch self {
        case .red: return "RED"
        case .blue: return "BLUE"
        case .green: return "GREEN"
        case .yellow: return "YELLOW"
        case .orange: return "ORANGE"
        case .purple: return "PURPLE"
        case .pink: return "PINK"
        case .cyan: return "CYAN"
        case .brown: return "BROWN"
        case .gray: return "GRAY"
        }
    }

    var swiftUIColor: Color {
        switch self {
        case .red: return .red
        case .blue: return .blue
        case .green: return .green
        case .yellow: return .yellow
        case .orange: return .orange
        case .purple: return .purple
        case .pink: return .pink
        case .cyan: return .cyan
        case .brown: return .brown
        case .gray: return .gray
        }
    }
}


enum Difficulty {
    case easy, medium, hard
    
    var gridSize: Int {
        switch self {
        case .easy: return 3
        case .medium: return 5
        case .hard: return 7
        }
    }
}

struct ContentView: View {
    
    @State private var selectedDifficulty: Difficulty? = nil
    @State private var targetColor = GameColor.allCases.randomElement()!
    @State private var options: [GameColor] = []
    @State private var score = 0
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var gameOver = false
    @State private var tappedIndices: Set<Int> = []

    var body: some View {
        VStack(spacing: 30) {
            if selectedDifficulty == nil {
                // Difficulty selection screen
                Text("Select Difficulty")
                    .font(.largeTitle)
                    .bold()
                
                VStack(spacing: 20) {
                    Button("Easy") { startGame(.easy) }
                        .difficultyButtonStyle()
                    Button("Medium") { startGame(.medium) }
                        .difficultyButtonStyle()
                    Button("Hard") { startGame(.hard) }
                        .difficultyButtonStyle()
                }
                .padding(.horizontal, 40) // optional padding so they don't touch screen edgesdifficultyButtonStyle

                Spacer()
            } else {
                // Game UI goes here
                Text("Match the Color")
                    .font(.largeTitle)
                    .bold()
                
                Text("Score: \(score)")
                    .font(.title2)
                
                if !gameOver {
                    HStack(spacing: 15) {
                        Rectangle()
                            .fill(targetColor.swiftUIColor)
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                        
                        Text(targetColor.name)
                            .font(.title)
                            .bold()
                    }
                }
                
                if !gameOver, let difficulty = selectedDifficulty {
                    let gridSize = difficulty.gridSize
                    
                    GeometryReader { geometry in
                        let spacing: CGFloat = 10
                        let totalSpacing = spacing * CGFloat(gridSize - 1)
                        let squareWidth = (geometry.size.width - totalSpacing - 20) / CGFloat(gridSize)
                        // 20 is optional padding adjustment

                        let columns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: gridSize)

                        LazyVGrid(columns: columns, spacing: spacing) {
                            ForEach(options.indices, id: \.self) { index in
                                let color = options[index]
                                
                                Button {
                                    checkAnswer(at: index)
                                } label: {
                                    Rectangle()
                                        .fill(color.swiftUIColor)
                                        .opacity(tappedIndices.contains(index) ? 0.3 : 1)
                                        .frame(width: squareWidth, height: squareWidth) // square!
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(height: CGFloat(difficulty.gridSize) * 60) // approximate height for GeometryReader
                }

                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.headline)
                }
                
                if gameOver {
                    Button("Restart Game") {
                        restartGame()
                    }
                    .padding()
                }
            }
        }

        .padding()
    }
    
    // MARK: - Game Logic
    
    func startGame(_ difficulty: Difficulty) {
        selectedDifficulty = difficulty
        resetRound()
    }
    
    func resetRound() {
        tappedIndices.removeAll()
        showError = false
        gameOver = false
        score = 0
        newRound()
    }
    
    func newRound() {
        guard let difficulty = selectedDifficulty else { return }
        
        let colors = availableColors(for: difficulty)
        
        targetColor = colors.randomElement()!
        
        let totalSquares = difficulty.gridSize * difficulty.gridSize
        
        options = (0..<totalSquares).map { _ in
            colors.randomElement()!
        }
        
        // Ensure at least one correct answer
        options[Int.random(in: 0..<totalSquares)] = targetColor
    }

    func checkAnswer(at index: Int) {
        let selected = options[index]
        
        if selected == targetColor {
            tappedIndices.insert(index)
            score += 1
            
            // Check if all target colors are tapped
            let remaining = options.indices.filter { options[$0] == targetColor && !tappedIndices.contains($0) }
            if remaining.isEmpty {
                tappedIndices.removeAll()
                newRound()
            }
        } else {
            errorMessage = "You Lost!"
            showError = true
            gameOver = true
        }
    }
    
    func availableColors(for difficulty: Difficulty) -> [GameColor] {
        switch difficulty {
        case .easy:
            return [.red, .blue, .green, .yellow]
        case .medium:
            return [.red, .blue, .green, .yellow, .orange, .purple]
        case .hard:
            return [.red, .blue, .green, .yellow, .orange, .purple, .pink, .cyan]
        }
    }

    
    func restartGame() {
        tappedIndices.removeAll()
        score = 0
        showError = false
        gameOver = false
        selectedDifficulty = nil
    }
}

// MARK: - Button style helper
extension View {
    func difficultyButtonStyle() -> some View {
        self
            .font(.title2)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(radius: 3)
    }
}

#Preview {
    ContentView()
}
