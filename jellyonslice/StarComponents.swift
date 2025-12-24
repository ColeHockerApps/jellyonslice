import SwiftUI
import Combine

struct StarPrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(StarTheme.buttonFont())
                .foregroundColor(StarTheme.textPrimary)
                .padding(.horizontal, 22)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: StarTheme.cornerRadius, style: .continuous)
                        .fill(StarTheme.accent)
                )
                .shadow(color: StarTheme.glow.opacity(0.6), radius: 14, x: 0, y: 0)
        }
    }
}

struct StarIconButton: View {
    let systemName: String
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(StarTheme.textPrimary)
                .frame(width: 38, height: 38)
                .background(
                    Circle()
                        .fill(StarTheme.surfaceStrong)
                )
                .shadow(color: StarTheme.shadow, radius: 10, x: 0, y: 6)
        }
    }
}

struct StarCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: StarTheme.cornerRadius, style: .continuous)
                    .fill(StarTheme.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: StarTheme.cornerRadius, style: .continuous)
                            .stroke(StarTheme.borderSoft, lineWidth: 1)
                    )
            )
            .shadow(color: StarTheme.shadow, radius: 12, x: 0, y: 8)
    }
}

struct StarDivider: View {
    var body: some View {
        Rectangle()
            .fill(StarTheme.borderSoft)
            .frame(height: 1)
            .opacity(0.6)
    }
}
