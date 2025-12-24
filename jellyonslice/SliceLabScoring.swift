import SwiftUI
import Combine

@MainActor
final class SliceLabScoring: ObservableObject {

    @Published private(set) var score: Int = 0
    @Published private(set) var combo: Int = 0
    @Published private(set) var bestCombo: Int = 0

    private var comboTimer: Timer?
    private let comboTimeout: TimeInterval = 1.2

    func reset() {
        score = 0
        combo = 0
        bestCombo = 0
        comboTimer?.invalidate()
        comboTimer = nil
    }

    func registerSlice(hitCount: Int) {
        guard hitCount > 0 else { return }

        combo += 1
        bestCombo = max(bestCombo, combo)

        let basePoints = hitCount * 10
        let comboBonus = combo * 5
        score += basePoints + comboBonus

        restartComboTimer()
    }

    func registerMiss() {
        combo = 0
        comboTimer?.invalidate()
        comboTimer = nil
    }

    private func restartComboTimer() {
        comboTimer?.invalidate()
        comboTimer = Timer.scheduledTimer(withTimeInterval: comboTimeout, repeats: false) { [weak self] _ in
            self?.combo = 0
        }
    }
}
