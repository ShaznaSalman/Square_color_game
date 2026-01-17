//
//  LevelSelectorView.swift
//  Square_color_game
//
//  Created by COBSCCOMP24.2P-019 on 2026-01-17.
//

import SwiftUI

struct LevelSelectorView: View { let onSelect: (String) -> Void

var body: some View {
    VStack(spacing: 15) {
        GlossyButton(title: "Easy (3x3)", colors: [.green, .mint]) {
            onSelect("easy")
        }

        GlossyButton(title: "Medium (5x5)", colors: [.yellow, .orange]) {
            onSelect("medium")
        }

        GlossyButton(title: "Hard (7x7)", colors: [.red, .pink]) {
            onSelect("hard")
        }
    }
}
}
