import SwiftUI
import Combine

@MainActor
final class AppRouter: ObservableObject {

    enum Route {
        case main
        case settings
        case privacy
    }

    @Published var route: Route = .main

    func goMain() {
        route = .main
    }

    func goSettings() {
        route = .settings
    }

    func goPrivacy() {
        route = .privacy
    }
}
