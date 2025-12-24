import SwiftUI

enum StarTokens {

    enum Colors {
        static let spaceDark = Color(red: 0.03, green: 0.02, blue: 0.08)
        static let spaceMid = Color(red: 0.08, green: 0.06, blue: 0.18)
        static let spaceLight = Color(red: 0.14, green: 0.10, blue: 0.28)

        static let starYellow = Color(red: 0.98, green: 0.82, blue: 0.42)
        static let starOrange = Color(red: 0.96, green: 0.62, blue: 0.24)
        static let starPink = Color(red: 0.92, green: 0.44, blue: 0.62)

        static let textMain = Color.white
        static let textSoft = Color.white.opacity(0.65)

        static let overlay = Color.black.opacity(0.35)
        static let shadow = Color.black.opacity(0.55)
    }

    enum Gradients {
        static let background = LinearGradient(
            colors: [
                Colors.spaceLight,
                Colors.spaceDark
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let starGlow = RadialGradient(
            colors: [
                Colors.starYellow.opacity(0.9),
                Colors.starYellow.opacity(0.4),
                Color.clear
            ],
            center: .center,
            startRadius: 2,
            endRadius: 120
        )
    }

    enum Radius {
        static let chip: CGFloat = 10
        static let card: CGFloat = 18
        static let panel: CGFloat = 26
    }

    enum Spacing {
        static let xs: CGFloat = 6
        static let sm: CGFloat = 10
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 34
    }

    enum Motion {
        static let slice: Double = 0.14
        static let pop: Double = 0.22
        static let float: Double = 0.8
        static let idle: Double = 1.6
    }

    enum Sizes {
        static let starSmall: CGFloat = 18
        static let starMedium: CGFloat = 34
        static let starLarge: CGFloat = 56
    }
}
