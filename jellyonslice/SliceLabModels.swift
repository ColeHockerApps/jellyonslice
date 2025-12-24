import SwiftUI
import Combine

enum SliceObjectKind: String, Codable, CaseIterable {
    case jelly
    case star
    case bomb
    case ropeNode
    case bonus
}

struct SliceCut: Identifiable, Hashable {
    let id: UUID
    var points: [CGPoint]
    var createdAt: TimeInterval

    init(points: [CGPoint], createdAt: TimeInterval) {
        self.id = UUID()
        self.points = points
        self.createdAt = createdAt
    }
}

struct SliceObject: Identifiable, Hashable {
    let id: UUID
    var kind: SliceObjectKind
    var position: CGPoint
    var velocity: CGVector
    var radius: CGFloat
    var isAlive: Bool
    var scoreValue: Int
    var spawnAt: TimeInterval

    init(kind: SliceObjectKind,
         position: CGPoint,
         velocity: CGVector,
         radius: CGFloat,
         isAlive: Bool = true,
         scoreValue: Int,
         spawnAt: TimeInterval) {
        self.id = UUID()
        self.kind = kind
        self.position = position
        self.velocity = velocity
        self.radius = radius
        self.isAlive = isAlive
        self.scoreValue = scoreValue
        self.spawnAt = spawnAt
    }
}

struct SliceRope: Identifiable, Hashable {
    let id: UUID
    var startPoint: CGPoint
    var endPoint: CGPoint
    var mass: CGFloat
    var isIntact: Bool

    init(startPoint: CGPoint, endPoint: CGPoint, mass: CGFloat, isIntact: Bool = true) {
        self.id = UUID()
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.mass = mass
        self.isIntact = isIntact
    }
}

struct SliceDetachedObject: Identifiable, Hashable {
    let id: UUID
    var position: CGPoint
    var velocity: CGVector
    var mass: CGFloat

    init(position: CGPoint, velocity: CGVector, mass: CGFloat) {
        self.id = UUID()
        self.position = position
        self.velocity = velocity
        self.mass = mass
    }
}

struct SliceLevelState: Hashable {
    var levelIndex: Int
    var score: Int
    var strikes: Int
    var isOver: Bool

    var objects: [SliceObject]
    var ropes: [SliceRope]
    var recentCuts: [SliceCut]

    var worldSize: CGSize
    var gravity: CGFloat

    init(levelIndex: Int,
         score: Int = 0,
         strikes: Int = 0,
         isOver: Bool = false,
         objects: [SliceObject] = [],
         ropes: [SliceRope] = [],
         recentCuts: [SliceCut] = [],
         worldSize: CGSize,
         gravity: CGFloat = 980) {
        self.levelIndex = levelIndex
        self.score = score
        self.strikes = strikes
        self.isOver = isOver
        self.objects = objects
        self.ropes = ropes
        self.recentCuts = recentCuts
        self.worldSize = worldSize
        self.gravity = gravity
    }
}

struct SliceSessionState: Hashable {
    var totalScore: Int
    var combo: Int
    var bestCombo: Int
    var isRunning: Bool

    init(totalScore: Int = 0,
         combo: Int = 0,
         bestCombo: Int = 0,
         isRunning: Bool = false) {
        self.totalScore = totalScore
        self.combo = combo
        self.bestCombo = bestCombo
        self.isRunning = isRunning
    }
}
