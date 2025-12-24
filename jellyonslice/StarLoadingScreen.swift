import SwiftUI
import Combine

struct StarLoadingScreen: View {

    @State private var spin = false
    @State private var pulse = false
    @State private var sparkle = false

    var body: some View {
        ZStack {
            StarTheme.background
                .ignoresSafeArea()

            VStack(spacing: 28) {
                ZStack {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    StarTheme.accentPrimary.opacity(0.2),
                                    StarTheme.accentPrimary.opacity(0.8),
                                    StarTheme.accentPrimary.opacity(0.2)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 160, height: 160)
                        .rotationEffect(.degrees(spin ? 360 : 0))
                        .animation(
                            .linear(duration: 2.2)
                                .repeatForever(autoreverses: false),
                            value: spin
                        )

                    ForEach(0..<6, id: \.self) { i in
                        StarGlyphs.star(
                            size: 14,
                            color: StarTheme.accentPrimary
                        )
                        .opacity(sparkle ? 1 : 0.3)
                        .offset(y: -80)
                        .rotationEffect(.degrees(Double(i) * 60))
                        .scaleEffect(pulse ? 1.15 : 0.85)
                        .animation(
                            .easeInOut(duration: 1.4)
                                .repeatForever()
                                .delay(Double(i) * 0.15),
                            value: pulse
                        )
                    }
                }

                VStack(spacing: 6) {
                    Text("Loading Stars")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(StarTheme.textPrimary)

                    Text("Aligning constellations")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(StarTheme.textSecondary)
                }
            }
        }
        .onAppear {
            spin = true
            pulse = true
            sparkle = true
        }
    }
}
