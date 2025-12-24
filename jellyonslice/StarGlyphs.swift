import SwiftUI

enum StarGlyphs {

    static func star(size: CGFloat, color: Color) -> some View {
        Image(systemName: "star.fill")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundStyle(color)
            .shadow(color: StarTokens.Colors.shadow, radius: size * 0.35, x: 0, y: size * 0.25)
    }

    static func sparkle(size: CGFloat, color: Color) -> some View {
        Image(systemName: "sparkles")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundStyle(color)
            .shadow(color: color.opacity(0.6), radius: size * 0.5)
    }

    static func sliceTrail(width: CGFloat, height: CGFloat) -> some View {
        Capsule()
            .fill(
                LinearGradient(
                    colors: [
                        StarTokens.Colors.starYellow.opacity(0.9),
                        StarTokens.Colors.starPink.opacity(0.6),
                        Color.clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: width, height: height)
            .blur(radius: height * 0.6)
    }

    static func glowCircle(size: CGFloat, color: Color) -> some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        color.opacity(0.85),
                        color.opacity(0.35),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 1,
                    endRadius: size * 0.9
                )
            )
            .frame(width: size, height: size)
    }

    static func orb(size: CGFloat, core: Color, glow: Color) -> some View {
        ZStack {
            glowCircle(size: size * 1.4, color: glow)
            Circle()
                .fill(core)
                .frame(width: size, height: size)
                .shadow(color: glow.opacity(0.8), radius: size * 0.6)
        }
    }
}
