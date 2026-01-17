//
//  CardView.swift
//  Square_color_game
//
//  Created by COBSCCOMP24.2P-019 on 2026-01-17.
//

import SwiftUI

struct CardView: View { let card: GameCard

var body: some View {
    ZStack {
        RoundedRectangle(cornerRadius: 8)
            .fill(card.isFlipped || card.isMatched ? card.color : Color.gray.opacity(0.7))
            .frame(width: 50, height: 50)
            .shadow(radius: 3)

        if card.isFlipped || card.isMatched {
            if card.isBomb {
                Text("💣")
                    .font(.system(size: 22))
            }
        } else {
            Text("?")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
        }
    }
    .animation(.easeInOut(duration: 0.2), value: card.isFlipped)
}
}
