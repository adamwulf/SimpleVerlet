//
//  File.swift
//  
//
//  Created by Adam Wulf on 8/11/22.
//

import Foundation
import SwiftToolbox
import CoreGraphics

public class Point: PhysicsObject {
    public var mass: CGFloat = 0
    public var location: CGPoint
    public var oldLocation: CGPoint
    public var immovable: Bool
    public var attachable: Bool
    public var radius: CGFloat = 0

    public var x: CGFloat {
        get {
            return location.x
        }
        set {
            assert(!newValue.isNaN && newValue.isFinite)
            location.x = newValue
        }
    }

    public var y: CGFloat {
        get {
            return location.y
        }
        set {
            assert(!newValue.isNaN && newValue.isFinite)
            location.y = newValue
        }
    }

    public var area: CGFloat {
        get {
            return CGFloat.pi * radius * radius
        }
        set {
            radius = sqrt(newValue / CGFloat.pi)
        }
    }

    /// momentum = mass * velocity
    public var momentum: CGFloat {
        return mass * velocity.magnitude
    }

    /// K = 1/2 * m * v^2
    public var kineticEnergy: CGFloat {
        return 0.5 * mass * velocity.magnitude * velocity.magnitude
    }

    public override convenience init() {
        self.init(.zero)
    }

    convenience init(_ x: CGFloat, _ y: CGFloat) {
        self.init(CGPoint(x, y))
    }

    public init(_ point: CGPoint) {
        location = point
        oldLocation = location
        immovable = false
        attachable = true
    }

    public var description: String {
        return "[Point \(location.x),\(location.y)]"
    }

    public var velocity: CGVector {
        get {
            return location - oldLocation
        }
        set {
            oldLocation = location - newValue
        }
    }

    public func distance(to point: Point) -> CGFloat {
        let dx = location.x - point.location.x
        let dy = location.y - point.location.y
        return sqrt(dx * dx + dy * dy)
    }

    public func nullVelocity() {
        oldLocation = location
    }

    public override func bump() {
        oldLocation.x = location.x + CGFloat(arc4random() % 10) - 5
        oldLocation.y = location.y + CGFloat(arc4random() % 10) - 5
    }

    public override func update(_ epsilon: TimeInterval, friction: CGFloat, forces: [PhysicsForce]) {
        guard !immovable else { return }
        var velocity = self.velocity
        for force in forces {
            let accel = force.acceleration(at: location, for: mass)
            let deltaV = accel * epsilon
            velocity += deltaV
        }
        let vel = velocity * (1 - friction)
        oldLocation = location
        location = location + vel
    }

    public override func collide(with others: [PhysicsObject]) {
        guard radius > 0 else { return }
        for point in others {
            guard point != self else { continue }
            if let point = point as? Point {
                guard point.radius > 0 else { return }

                let dist = distance(to: point)
                let move = radius + point.radius - dist

                if dist == 0 {
                    bump()
                } else if move > 0 {
                    let v1 = Self.velocityAfterCollision(self, point)
                    let v2 = Self.velocityAfterCollision(point, self)

                    let distToMove = (point.location - location) / dist * move

                    location = location - distToMove / 2
                    point.location = point.location + distToMove / 2

                    self.velocity = v1
                    point.velocity = v2
                }
            }
        }
    }

    public func constrain() {
        // noop
    }

    static func velocityAfterCollision(_ p1: Point, _ p2: Point) -> CGVector {
        guard p1.mass != 0, p2.mass != 0 else { return p1.velocity }
        let term1 = p1.velocity
        let term2 = -2 * p2.mass / (p1.mass + p2.mass)
        let locDiff = p1.location - p2.location
        let term3 = ((p1.velocity - p2.velocity) ⋅ (p1.location - p2.location)) / locDiff.magnitude.squared()
        let term4 = locDiff

        return term1 + (term2 * term3 * term4)
    }
}
