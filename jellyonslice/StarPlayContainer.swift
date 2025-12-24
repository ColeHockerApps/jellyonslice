import Combine
import SwiftUI

struct StarPlayContainer: View {

    @EnvironmentObject private var orientation: StarOrientationManager
    @EnvironmentObject private var launch: StarLaunchPoints

    @StateObject private var model = StarPlayContainerModel()

    let onReady: () -> Void

    init(onReady: @escaping () -> Void) {
        self.onReady = onReady
    }

    var body: some View {
        ZStack {
            StarTheme.background
                .ignoresSafeArea()

            ZStack {
                Color.black.opacity(0.85)
                    .ignoresSafeArea()

                StarPlayView(
                    startPoint: launch.restoreResume() ?? launch.mainPoint,
                    launch: launch,
                    orientation: orientation
                ) {
                    model.markReady()
                    onReady()
                }
                .opacity(model.fadeIn ? 1 : 0)
                .animation(Animation.easeOut(duration: 0.35), value: model.fadeIn)

                if model.isReady == false {
                    loadingOverlay
                }
            }

            Color.black
                .opacity(model.dimLayer)
                .ignoresSafeArea()
                .allowsHitTesting(false)
                .animation(Animation.easeOut(duration: 0.25), value: model.dimLayer)
        }
        .onAppear {
            model.onAppear()
            orientation.allowFlexible()
        }
    }

    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                StarLoadingOrbit()
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(StarTheme.surfaceStrong)
            )
        }
        .transition(.opacity)
    }
}

final class StarPlayContainerModel: ObservableObject {

    @Published var isReady: Bool = false
    @Published var fadeIn: Bool = false
    @Published var dimLayer: Double = 1.0

    func onAppear() {
        isReady = false
        fadeIn = false
        dimLayer = 1.0

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.dimLayer = 0.0
        }
    }

    func markReady() {
        guard isReady == false else { return }
        isReady = true
        fadeIn = true
    }
}

struct StarLoadingOrbit: View {

    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            Circle()
                .stroke(StarTheme.accent.opacity(0.25), lineWidth: 3)
                .frame(width: 44, height: 44)

            Circle()
                .fill(StarTheme.accent)
                .frame(width: 8, height: 8)
                .offset(y: -22)
                .rotationEffect(.degrees(rotation))
        }
        .onAppear {
            withAnimation(
                Animation.linear(duration: 1.2)
                    .repeatForever(autoreverses: false)
            ) {
                rotation = 360
            }
        }
    }
}
