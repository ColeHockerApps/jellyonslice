import SwiftUI
import Combine

@MainActor
final class SliceLabRopeSolver: ObservableObject {

    @Published private(set) var ropes: [SliceRope] = []
    @Published private(set) var detachedObjects: [SliceDetachedObject] = []

    func setup(ropes: [SliceRope]) {
        self.ropes = ropes
        detachedObjects.removeAll()
    }

    func registerCut(points: [CGPoint]) {
        guard points.count >= 2 else { return }

        for i in ropes.indices {
            guard ropes[i].isIntact else { continue }
            if intersects(rope: ropes[i], with: points) {
                cutRope(at: i)
            }
        }
    }

    private func cutRope(at index: Int) {
        guard ropes.indices.contains(index) else { return }
        ropes[index].isIntact = false

        let detached = SliceDetachedObject(
            position: ropes[index].endPoint,
            velocity: CGVector(dx: CGFloat.random(in: -80...80),
                               dy: CGFloat.random(in: -120...0)),
            mass: ropes[index].mass
        )
        detachedObjects.append(detached)
    }

    func update(delta: TimeInterval) {
        for i in detachedObjects.indices {
            detachedObjects[i].velocity.dy += 980 * delta
            detachedObjects[i].position.x += detachedObjects[i].velocity.dx * delta
            detachedObjects[i].position.y += detachedObjects[i].velocity.dy * delta
        }
        detachedObjects.removeAll { $0.position.y > 1000 }
    }

    private func intersects(rope: SliceRope, with points: [CGPoint]) -> Bool {
        for i in 1..<points.count {
            let a = points[i - 1]
            let b = points[i]
            if segmentsIntersect(a, b, rope.startPoint, rope.endPoint) {
                return true
            }
        }
        return false
    }

    private func segmentsIntersect(_ p1: CGPoint, _ p2: CGPoint,
                                   _ p3: CGPoint, _ p4: CGPoint) -> Bool {
        let d1 = direction(p3, p4, p1)
        let d2 = direction(p3, p4, p2)
        let d3 = direction(p1, p2, p3)
        let d4 = direction(p1, p2, p4)

        if d1 * d2 < 0 && d3 * d4 < 0 {
            return true
        }
        return false
    }

    private func direction(_ a: CGPoint, _ b: CGPoint, _ c: CGPoint) -> CGFloat {
        (c.x - a.x) * (b.y - a.y) - (c.y - a.y) * (b.x - a.x)
    }
}
