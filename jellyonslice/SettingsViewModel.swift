import SwiftUI
import Combine

@MainActor
final class SettingsViewModel: ObservableObject {

    @Published var hapticsEnabled: Bool = true
    @Published var soundEnabled: Bool = true

    private let hapticsKey = "jellyon.settings.haptics"
    private let soundKey = "jellyon.settings.sound"

    init() {
        hapticsEnabled = UserDefaults.standard.object(forKey: hapticsKey) as? Bool ?? true
        soundEnabled = UserDefaults.standard.object(forKey: soundKey) as? Bool ?? true
    }

    func setHaptics(_ value: Bool) {
        hapticsEnabled = value
        UserDefaults.standard.set(value, forKey: hapticsKey)
    }

    func setSound(_ value: Bool) {
        soundEnabled = value
        UserDefaults.standard.set(value, forKey: soundKey)
    }
}
