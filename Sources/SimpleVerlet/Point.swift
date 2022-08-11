//
//  File.swift
//  
//
//  Created by Adam Wulf on 8/11/22.
//

import Foundation
import SwiftToolbox

public class Point: PhysicsObject {
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

    public override convenience init() {
        self.init(.zero)
    }

    public init(_ point: CGPoint) {
        location = .zero
        oldLocation = location
        immovable = false
        attachable = true
    }

    public var description: String {
        return "[Point \(location.x),\(location.y)]"
    }

    public var velocity: CGVector {
        return location - oldLocation
    }

    public func distance(to point: Point) -> CGFloat {
        let dx = location.x - point.location.x
        let dy = location.y - point.location.y;
        return sqrt(dx * dx + dy * dy);
    }

    public func nullVelocity() {
        oldLocation = location
    }

    public override func bump() {
        oldLocation.x = location.x + CGFloat(arc4random() % 10 - 5)
        oldLocation.y = location.y + CGFloat(arc4random() % 10 - 5)
    }

    public override func update(with friction: CGFloat) {
        guard !immovable else { return }
        let vel = velocity * friction
        oldLocation = location
        location = location + vel
    }

    public func collide(with others: [PhysicsObject]) {
        guard radius > 0 else { return }
        for point in others {
            if let point = point as? Point {
                guard point.radius > 0 else { return }

                let dist = distance(to: point);
                let move = radius + point.radius - dist

                if dist == 0 {
                    bump()
                } else if move > 0 {
                    let distToMove = (point.location - location) / dist * move

                    location = location - distToMove / 2
                    point.location = point.location - distToMove / 2
                }
            }
        }
    }

    public override func constrain() {
        // noop
    }
}