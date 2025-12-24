import SwiftUI
import Combine
import UIKit

final class SliceLabScene: ObservableObject {

    struct StarNode: Identifiable {
        let id = UUID()
        var position: CGPoint
        var velocity: CGVector
        var radius: CGFloat
        var isAttached: Bool
    }

    @Published private(set) var stars: [StarNode] = []
    @Published private(set) var score: Int = 0
    @Published private(set) var combo: Int = 0

    private var displayLink: CADisplayLink?
    private var lastTimestamp: CFTimeInterval = 0

    private let gravity: CGFloat = 1400
    private let bounds: CGRect

    init(bounds: CGRect) {
        self.bounds = bounds
    }

    func start() {
        stop()
        spawnInitialStars()
        lastTimestamp = CACurrentMediaTime()
        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink?.add(to: .main, forMode: .common)
    }

    func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }

    func slice(at point: CGPoint) {
        var hit = false

        stars = stars.map { star in
            guard star.isAttached == false else { return star }
            let dx = star.position.x - point.x
            let dy = star.position.y - point.y
            let dist = sqrt(dx * dx + dy * dy)

            if dist <= star.radius {
                hit = true
                var v = star.velocity
                v.dx += CGFloat.random(in: -300...300)
                v.dy = -abs(v.dy) - CGFloat.random(in: 200...400)
                return StarNode(
                    position: star.position,
                    velocity: v,
                    radius: star.radius * 0.75,
                    isAttached: false
                )
            }
            return star
        }

        if hit {
            combo += 1
            score += 10 * combo
            SliceLabHaptics.shared.slice()
        } else {
            combo = 0
        }
    }

    @objc private func step(link: CADisplayLink) {
        let dt = link.timestamp - lastTimestamp
        lastTimestamp = link.timestamp

        stars = stars.map { star in
            guard star.isAttached == false else { return star }

            var pos = star.position
            var vel = star.velocity

            vel.dy += gravity * dt
            pos.x += vel.dx * dt
            pos.y += vel.dy * dt

            if pos.x < 0 || pos.x > bounds.width {
                vel.dx *= -0.8
            }

            if pos.y > bounds.height + star.radius {
                vel.dy *= -0.6
                pos.y = bounds.height + star.radius
                combo = 0
            }

            return StarNode(
                position: pos,
                velocity: vel,
                radius: star.radius,
                isAttached: false
            )
        }
    }

    private func spawnInitialStars() {
        stars = (0..<6).map { _ in
            StarNode(
                position: CGPoint(
                    x: CGFloat.random(in: 40...(bounds.width - 40)),
                    y: CGFloat.random(in: -200 ... -40)
                ),
                velocity: CGVector(
                    dx: CGFloat.random(in: -200...200),
                    dy: CGFloat.random(in: 300...600)
                ),
                radius: CGFloat.random(in: 18...26),
                isAttached: false
            )
        }
    }
}
