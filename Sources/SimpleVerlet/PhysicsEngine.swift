//
//  PhysicsEngine.swift
//  
//
//  Created by Adam Wulf on 9/6/22.
//

import Foundation

public class PhysicsEngine {
    public private(set) var objects: [PhysicsObject] = []
    public private(set) var forces: [PhysicsForce] = []

    public init() {
        // noop
    }

    public func tick(_ epsilon: TimeInterval) {
        for object in objects {
            object.update(epsilon, friction: 1, forces: forces)
        }
        for object in objects {
            object.collide(with: objects)
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
