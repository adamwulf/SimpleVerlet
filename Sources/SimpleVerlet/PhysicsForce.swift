//
//  PhysicsForce.swift
//  
//
//  Created by Adam Wulf on 9/6/22.
//

import Foundation
import CoreGraphics

public class PhysicsForce: Equatable, Identifiable {
    public typealias ID = UUID

    public var id = UUID()

    public func acceleration(at point: CGPoint, for mass: CGFloat) -> CGVector {
        return .zero
    }

    public static func == (lhs: PhysicsForce, rhs: PhysicsForce) -> Bool {
        return lhs.id == rhs.id
    }
}
