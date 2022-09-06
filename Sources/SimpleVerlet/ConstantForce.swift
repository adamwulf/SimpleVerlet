//
//  File.swift
//  
//
//  Created by Adam Wulf on 9/6/22.
//

import Foundation
import CoreGraphics

public class ConstantForce: PhysicsForce {
    private let force: CGVector

    public init(_ force: CGVector) {
        self.force = force
    }

    public override func force(at point: CGPoint) -> CGVector {
        return force
    }
}
