//
//  ToastView.swift
//  Square_color_game
//
//  Created by COBSCCOMP24.2P-019 on 2026-01-17.
//

import SwiftUI

struct ToastView: View { let message: String

var body: some View {
    Text(message)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            LinearGradient(colors: [.red, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(12)
        .foregroundColor(.white)
        .fontWeight(.bold)
        .shadow(radius: 10)
        .padding(.top, 20)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.trailing, 20)
}
}
