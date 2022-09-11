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
    @Clamped(0...1) public var friction: CGFloat = 0
    public var box: CGRect?

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
            if let box = box {
                for point in points {
                    if point.location.x < box.minX + point.radius {
                        let overshoot = box.minX + point.radius - point.location.x
                        let velocity = point.velocity
                        point.location.x = box.minX + point.radius + overshoot
                        point.velocity.dx = -velocity.dx
                    }
                    if point.location.y < box.minY + point.radius {
                        let overshoot = box.minY + point.radius - point.location.y
                        let velocity = point.velocity
                        point.location.y = box.minY + point.radius + overshoot
                        point.velocity.dy = -velocity.dy
                    }
                    if point.location.x > box.maxX - point.radius {
                        let overshoot = box.maxX - point.radius - point.location.x
                        let velocity = point.velocity
                        point.location.x = box.maxX - point.radius + overshoot
                        point.velocity.dx = -velocity.dx
                    }
                    if point.location.y > box.maxY - point.radius {
                        let overshoot = box.maxY - point.radius - point.location.y
                        let velocity = point.velocity
                        point.location.y = box.maxY - point.radius + overshoot
                        point.velocity.dy = -velocity.dy
                    }
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
