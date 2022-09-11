//
//  File.swift
//  
//
//  Created by Adam Wulf on 9/6/22.
//

import Foundation
import CoreGraphics
import SwiftToolbox

/// Applies a constant force in N
public class ConstantForce: PhysicsForce {
    private let force: CGVector

    /// - parameter force: the force measured in N
    public init(_ force: CGVector) {
        self.force = force
    }

    /// Returns the acceleration for the input mass at the given point
    public override func acceleration(at point: CGPoint, for mass: CGFloat) -> CGVector {
        return force / mass
    }
}
