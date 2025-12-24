import SwiftUI
import Combine

struct StarMainScreen: View {

    @EnvironmentObject private var orientation: StarOrientationManager

    @State private var showLoading: Bool = true
    @State private var minTimePassed: Bool = false
    @State private var surfaceReady: Bool = false

    var body: some View {
        ZStack {
            StarPlayContainer {
                surfaceReady = true
                tryFinishLoading()
            }
            .opacity(showLoading ? 0 : 1)
            .animation(.easeOut(duration: 0.35), value: showLoading)

            if showLoading {
                StarLoadingScreen()
                    .transition(.opacity)
            }
        }
        .onAppear {
            orientation.allowFlexible()

            showLoading = true
            minTimePassed = false
            surfaceReady = false

            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                minTimePassed = true
                tryFinishLoading()
            }
        }
    }

    private func tryFinishLoading() {
        guard minTimePassed && surfaceReady else { return }
        withAnimation(.easeOut(duration: 0.35)) {
            showLoading = false
        }
    }
}
