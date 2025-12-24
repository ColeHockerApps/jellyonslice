import SwiftUI
import Combine

@MainActor
final class SliceLabEngine: ObservableObject {

    @Published private(set) var session: SliceSessionState = SliceSessionState()
    @Published private(set) var level: SliceLevelState

    private var clock: TimeInterval = 0
    private var rng: UInt64 = 0x1234ABCD
    private var spawnCooldown: TimeInterval = 0

    init(worldSize: CGSize = CGSize(width: 390, height: 844), levelIndex: Int = 1) {
        self.level = SliceLevelState(levelIndex: levelIndex, worldSize: worldSize)
    }

    func reset(worldSize: CGSize? = nil, levelIndex: Int? = nil) {
        clock = 0
        spawnCooldown = 0
        session = SliceSessionState()
        let size = worldSize ?? level.worldSize
        let idx = levelIndex ?? level.levelIndex
        level = SliceLevelState(levelIndex: idx, worldSize: size)
    }

    func start() {
        session.isRunning = true
    }

    func stop() {
        session.isRunning = false
    }

    func setupRopes(_ ropes: [SliceRope]) {
        level.ropes = ropes
    }

    func registerCut(points: [CGPoint]) {
        guard session.isRunning, level.isOver == false else { return }
        guard points.count >= 2 else { return }
        let cut = SliceCut(points: points, createdAt: clock)
        level.recentCuts.append(cut)
        applyCut(cut)
    }

    func tick(delta: TimeInterval) {
        guard session.isRunning, level.isOver == false else { return }

        clock += max(0, delta)

        pruneCuts()
        spawnCooldown -= delta
        if spawnCooldown <= 0 {
            spawnWave()
        }

        stepObjects(delta: delta)
        resolveOutOfBounds()
    }

    private func pruneCuts() {
        if level.recentCuts.isEmpty { return }
        let keepFrom = clock - 0.35
        level.recentCuts.removeAll { $0.createdAt < keepFrom }
    }

    private func applyCut(_ cut: SliceCut) {
        var hitAny = false
        var hitBomb = false

        for i in level.objects.indices {
            guard level.objects[i].isAlive else { continue }
            if intersectsCircle(object: level.objects[i], cut: cut) {
                hitAny = true
                if level.objects[i].kind == .bomb {
                    hitBomb = true
                    level.objects[i].isAlive = false
                } else {
                    level.objects[i].isAlive = false
                    level.score += level.objects[i].scoreValue
                    session.totalScore += level.objects[i].scoreValue
                }
            }
        }

        if hitBomb {
            session.combo = 0
            level.strikes += 1
            if level.strikes >= 3 {
                level.isOver = true
                session.isRunning = false
            }
            return
        }

        if hitAny {
            session.combo += 1
            if session.combo > session.bestCombo { session.bestCombo = session.combo }
            if session.combo >= 3 {
                let bonus = min(10, session.combo)
                level.score += bonus
                session.totalScore += bonus
            }
        } else {
            session.combo = 0
        }
    }

    private func intersectsCircle(object: SliceObject, cut: SliceCut) -> Bool {
        let r = max(6, object.radius)
        let p = object.position

        let pts = cut.points
        if pts.count < 2 { return false }

        for i in 1..<pts.count {
            let a = pts[i - 1]
            let b = pts[i]
            if distancePointToSegment(p, a, b) <= r {
                return true
            }
        }
        return false
    }

    private func distancePointToSegment(_ p: CGPoint, _ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let ab = CGPoint(x: b.x - a.x, y: b.y - a.y)
        let ap = CGPoint(x: p.x - a.x, y: p.y - a.y)
        let ab2 = ab.x * ab.x + ab.y * ab.y
        if ab2 <= 0.000001 {
            return hypot(p.x - a.x, p.y - a.y)
        }
        var t = (ap.x * ab.x + ap.y * ab.y) / ab2
        if t < 0 { t = 0 }
        if t > 1 { t = 1 }
        let proj = CGPoint(x: a.x + ab.x * t, y: a.y + ab.y * t)
        return hypot(p.x - proj.x, p.y - proj.y)
    }

    private func stepObjects(delta: TimeInterval) {
        let g = level.gravity
        let w = level.worldSize.width
        let h = level.worldSize.height

        for i in level.objects.indices {
            guard level.objects[i].isAlive else { continue }

            level.objects[i].velocity.dy += g * delta
            level.objects[i].position.x += level.objects[i].velocity.dx * delta
            level.objects[i].position.y += level.objects[i].velocity.dy * delta

            let r = level.objects[i].radius
            if level.objects[i].position.x < r {
                level.objects[i].position.x = r
                level.objects[i].velocity.dx *= -0.55
            } else if level.objects[i].position.x > (w - r) {
                level.objects[i].position.x = w - r
                level.objects[i].velocity.dx *= -0.55
            }

            if level.objects[i].position.y < -80 {
                level.objects[i].position.y = -80
            } else if level.objects[i].position.y > (h + 140) {
                level.objects[i].isAlive = false
            }
        }
    }

    private func resolveOutOfBounds() {
        let before = level.objects.count
        level.objects.removeAll { $0.isAlive == false }
        if before != level.objects.count {
            if level.objects.isEmpty {
                spawnCooldown = min(0.35, spawnCooldown)
            }
        }
    }

    private func spawnWave() {
        let count = Int(nextRand(in: 2...4))
        for _ in 0..<count {
            level.objects.append(spawnOne())
        }
        spawnCooldown = TimeInterval(nextRand(in: 0.55...1.05))
    }

    private func spawnOne() -> SliceObject {
        let w = level.worldSize.width
        let x = CGFloat(nextRand(in: 40...(max(41, Double(w) - 40))))
        let y = CGFloat(nextRand(in: Double(level.worldSize.height) * 0.7...Double(level.worldSize.height) - 40))

        let up = CGFloat(nextRand(in: 520...820))
        let side = CGFloat(nextRand(in: -140...140))

        let kindRoll = nextRand(in: 0...100)
        let kind: SliceObjectKind
        if kindRoll < 10 {
            kind = .bomb
        } else if kindRoll < 22 {
            kind = .star
        } else if kindRoll < 30 {
            kind = .bonus
        } else {
            kind = .jelly
        }

        let radius: CGFloat
        let score: Int
        switch kind {
        case .bomb:
            radius = 22
            score = 0
        case .star:
            radius = 18
            score = 3
        case .bonus:
            radius = 16
            score = 5
        case .ropeNode:
            radius = 14
            score = 1
        case .jelly:
            radius = 20
            score = 2
        }

        return SliceObject(
            kind: kind,
            position: CGPoint(x: x, y: y),
            velocity: CGVector(dx: side, dy: -up),
            radius: radius,
            isAlive: true,
            scoreValue: score,
            spawnAt: clock
        )
    }

    private func nextRand(in range: ClosedRange<Double>) -> Double {
        rng = rng &* 6364136223846793005 &+ 1442695040888963407
        let v = Double((rng >> 11) & 0x1FFFFFFFFFFFFF) / Double(0x1FFFFFFFFFFFFF)
        return range.lowerBound + (range.upperBound - range.lowerBound) * v
    }
}
