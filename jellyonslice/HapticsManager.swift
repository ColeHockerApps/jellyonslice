import Combine
import SwiftUI
import UIKit

@MainActor
final class HapticsManager: ObservableObject {

    static let shared = HapticsManager()

    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    private let notification = UINotificationFeedbackGenerator()
    private let selection = UISelectionFeedbackGenerator()

    private init() {
        impactLight.prepare()
        impactMedium.prepare()
        impactHeavy.prepare()
        notification.prepare()
        selection.prepare()
    }

    func tapLight() {
        impactLight.impactOccurred()
    }

    func tapMedium() {
        impactMedium.impactOccurred()
    }

    func tapHeavy() {
        impactHeavy.impactOccurred()
    }

    func success() {
        notification.notificationOccurred(.success)
    }

    func warning() {
        notification.notificationOccurred(.warning)
    }

    func error() {
        notification.notificationOccurred(.error)
    }

    func select() {
        selection.selectionChanged()
    }
}
