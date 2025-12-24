import Combine
import SwiftUI

@MainActor
final class StarLaunchStore: ObservableObject {

    static let shared = StarLaunchStore()

    @Published private(set) var launchPoint: URL?
    @Published private(set) var lastActivePoint: URL?

    private let launchKey = "jellyon.slice.stars.launch"
    private let lastKey = "jellyon.slice.stars.last"

    private init() {
        restore()
    }

    func setLaunchPoint(_ value: URL) {
        launchPoint = value
        UserDefaults.standard.set(value.absoluteString, forKey: launchKey)
    }

    func setLastActivePoint(_ value: URL?) {
        lastActivePoint = value
        if let value {
            UserDefaults.standard.set(value.absoluteString, forKey: lastKey)
        } else {
            UserDefaults.standard.removeObject(forKey: lastKey)
        }
    }

    func restore() {
        if let s = UserDefaults.standard.string(forKey: launchKey),
           let v = URL(string: s) {
            launchPoint = v
        }

        if let s = UserDefaults.standard.string(forKey: lastKey),
           let v = URL(string: s) {
            lastActivePoint = v
        }
    }

    func reset() {
        launchPoint = nil
        lastActivePoint = nil
        UserDefaults.standard.removeObject(forKey: launchKey)
        UserDefaults.standard.removeObject(forKey: lastKey)
    }
}
