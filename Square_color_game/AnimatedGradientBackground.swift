//
//  AnimatedGradientBackground.swift
//  Square_color_game
//
//  Created by COBSCCOMP24.2P-019 on 2026-01-17.
//

import SwiftUI

struct AnimatedGradientBackground: View { @State private var animate = false

var body: some View {
    LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 1.0, green: 0.77, blue: 0.88),
            Color(red: 0.65, green: 0.97, blue: 0.78),
            Color(red: 0.64, green: 0.80, blue: 0.98),
            Color(red: 1.0, green: 0.96, blue: 0.73)
        ]),
        startPoint: animate ? .topLeading : .bottomTrailing,
        endPoint: animate ? .bottomTrailing : .topLeading
    )
    .ignoresSafeArea()
    .animation(.easeInOut(duration: 15).repeatForever(autoreverses: true), value: animate)
    .onAppear {
        animate = true
    }
}
}

