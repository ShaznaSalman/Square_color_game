import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.bold)
                .padding()
                .frame(width: 180)
                .background(
                    LinearGradient(colors: [.orange, .red],
                                   startPoint: .top,
                                   endPoint: .bottom)
                )
                .cornerRadius(12)
                .foregroundColor(.white)
                .shadow(radius: 5)
        }
    }
}

struct GlossyButton: View {
    let title: String
    let colors: [Color]
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.bold)
                .padding()
                .frame(width: 160)
                .background(
                    LinearGradient(colors: colors,
                                   startPoint: .top,
                                   endPoint: .bottom)
                )
                .cornerRadius(14)
                .foregroundColor(.white)
                .shadow(radius: 6)
        }
        .scaleEffect(1.0)
        .buttonStyle(.plain)
    }
}
