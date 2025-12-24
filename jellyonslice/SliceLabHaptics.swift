import SwiftUI
import Combine
import UIKit

@MainActor
final class SliceLabHaptics {

    static let shared = SliceLabHaptics()

    private let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)

    private let successFeedback = UINotificationFeedbackGenerator()
    private let warningFeedback = UINotificationFeedbackGenerator()

    private init() {
        lightImpact.prepare()
        mediumImpact.prepare()
        heavyImpact.prepare()
        successFeedback.prepare()
        warningFeedback.prepare()
    }

    func slice() {
        lightImpact.impactOccurred(intensity: 0.7)
    }

    func combo() {
        mediumImpact.impactOccurred(intensity: 0.9)
    }

    func heavySlice() {
        heavyImpact.impactOccurred(intensity: 1.0)
    }

    func success() {
        successFeedback.notificationOccurred(.success)
    }

    func warning() {
        warningFeedback.notificationOccurred(.warning)
    }

    func error() {
        warningFeedback.notificationOccurred(.error)
    }

    func prepare() {
        lightImpact.prepare()
        mediumImpact.prepare()
        heavyImpact.prepare()
    }
}
