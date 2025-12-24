import SwiftUI
import Combine

@main
struct JellyonSliceStarsApp: App {

    @StateObject private var router = AppRouter()
    @StateObject private var orientation = StarOrientationManager.shared
    @StateObject private var launch = StarLaunchPoints()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(router)
                .environmentObject(orientation)
                .environmentObject(launch)
                .onAppear {
                    orientation.allowFlexible()
                }
        }
    }
}

private struct RootView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        ZStack {
            switch router.route {
            case .main:
                StarMainScreen()
            case .settings:
                SettingsScreen()
            case .privacy:
                PrivacyPageView()
            }
        }
    }
}
