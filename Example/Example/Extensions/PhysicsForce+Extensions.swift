//
//  PhysicsForce+Extensions.swift
//  Example
//
//  Created by Adam Wulf on 9/6/22.
//

import Foundation
import CoreGraphics
import SimpleVerlet

extension PhysicsForce {
    static let gravity = GravityForce(CGVector(dx: 0, dy: 10))
}
