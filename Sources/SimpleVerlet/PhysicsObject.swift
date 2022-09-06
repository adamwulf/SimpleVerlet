//
//  File.swift
//  
//
//  Created by Adam Wulf on 8/11/22.
//

import Foundation
import CoreGraphics

open class PhysicsObject: Equatable, Identifiable {
    public typealias ID = UUID

    public var id = UUID()

    open func bump() {
        // noop
    }

    open func update(_ epsilon: TimeInterval, friction: CGFloat, forces: [PhysicsForce]) {
        // noop
    }

    open func collide(with others: [PhysicsObject]) {
        // noop
    }

    public static func == (lhs: PhysicsObject, rhs: PhysicsObject) -> Bool {
        return lhs.id == rhs.id
    }
}
