//
//  GravityForce.swift
//  
//
//  Created by Adam Wulf on 9/11/22.
//

import Foundation
import CoreGraphics
import SwiftToolbox

/// Applies a constant force in N
public class GravityForce: PhysicsForce {
    private let acceleration: CGVector

    /// - parameter acceleration: the acceleration due to gravity measured in points per second^2
    public init(_ acceleration: CGVector) {
        self.acceleration = acceleration
    }

    /// returns the constant acceleration due to gravity, which is the same for any mass
    public override func acceleration(at point: CGPoint, for mass: CGFloat) -> CGVector {
        return acceleration
    }
}
