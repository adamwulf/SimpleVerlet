//
//  PhysicsEngine.swift
//  
//
//  Created by Adam Wulf on 9/6/22.
//

import Foundation
import SwiftToolbox
import CoreGraphics

public class PhysicsEngine {
    public private(set) var objects: [PhysicsObject] = []
    public private(set) var forces: [PhysicsForce] = []
    public var friction: CGFloat = 0.99

    public init() {
        // noop
    }

    public func tick(_ epsilon: TimeInterval) {
        for object in objects {
            object.update(epsilon, friction: friction, forces: forces)
        }
        for object in objects {
            object.collide(with: objects)
        }

        for object in objects {
            var points: [Point] = []
            if let point = object as? Point {
                points.append(point)
            } else if let stick = object as? Stick {
                points.append(stick.p0)
                points.append(stick.p1)
            }
            for point in points {
                if point.location.x < point.radius {
                    let velocity = point.velocity
                    point.location.x = point.radius
                    point.velocity.dx = -velocity.dx
                }
                if point.location.y < point.radius {
                    let velocity = point.velocity
                    point.location.y = point.radius
                    point.velocity.dy = -velocity.dy
                }
                if point.location.x > 500 - point.radius {
                    let velocity = point.velocity
                    point.location.x = 500 - point.radius
                    point.velocity.dx = -velocity.dx
                }
                if point.location.y > 500 - point.radius {
                    let velocity = point.velocity
                    point.location.y = 500 - point.radius
                    point.velocity.dy = -velocity.dy
                }
            }
        }
    }

    public func add(object: PhysicsObject) {
        objects.append(object)
    }

    public func remove(object: PhysicsObject) {
        objects.remove(object: object)
    }

    public func add(force: PhysicsForce) {
        forces.append(force)
    }

    public func remove(force: PhysicsForce) {
        forces.remove(object: force)
    }
}
