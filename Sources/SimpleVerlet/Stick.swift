//
//  File.swift
//  
//
//  Created by Adam Wulf on 8/11/22.
//

import Foundation
import SwiftToolbox
import CoreGraphics

public class Stick: PhysicsObject {
    public var p0: Point
    public var p1: Point
    public var length: CGFloat {
        didSet {
            constrain()
        }
    }

    public var stress: CGFloat {
        // calculate stress
        let currLength = p0.distance(to: p1)
        let percDiff = abs(currLength - length) / length

        // .0 => blue
        // .1 => red
        return min(0.1, percDiff) * 10
    }

    public init(p0: Point, p1: Point) {
        self.p0 = p0
        self.p1 = p1
        length = p0.distance(to: p1)
    }

    public init(p0: CGPoint, p1: CGPoint) {
        self.p0 = Point(p0)
        self.p1 = Point(p1)
        length = p0.distance(to: p1)
    }

    public override func update(_ epsilon: TimeInterval, friction: CGFloat, forces: [PhysicsForce]) {
        p0.update(epsilon, friction: friction, forces: forces)
        p1.update(epsilon, friction: friction, forces: forces)
        constrain()
    }

    public override func collide(with others: [PhysicsObject]) {
        p0.collide(with: others)
        p1.collide(with: others)

        for other in others {
            guard
                let point = other as? Point,
                point.radius > 0
            else { continue }

            let dist = point.location.distanceToLine(through: p0.location, and: p1.location)
            if dist < point.radius {
                let close = point.location.closestPointToLine(through: p0.location, and: p1.location)
                let vec = (point.location - close).normalized
                let diff = point.radius - dist
                point.location += vec * diff / 2
                p0.location -= vec * diff / 2
                p1.location -= vec * diff / 2
            }
        }
    }

    // MARK: - Helpers

    private func constrain() {
        let delta = p1.location - p0.location
        let distance = p1.distance(to: p0)

        let difference = length - distance
        var percent = difference / distance / 2
        if percent.isNaN || !percent.isFinite {
            percent = 0
        }
        let offset = delta * percent

        if !p0.immovable {
            p0.location = p0.location - offset
        }
        if !p1.immovable {
            p1.location = p1.location + offset
        }
    }
}

extension Stick {
    public func rotate(by rads: CGFloat) {
        let c = CGPoint(x: (p0.x + p1.x) / 2, y: (p0.y + p1.y) / 2)
        let transform: CGAffineTransform = .init(translationX: c.x, y: c.y).rotated(by: rads).translatedBy(x: -c.x, y: -c.y)

        let cgp0 = p0.location.applying(transform)
        let cgp1 = p1.location.applying(transform)

        self.p0.location = cgp0
        self.p1.location = cgp1
    }

    public func translate(by vec: CGVector) {
        p0.location = p0.location + vec
        p1.location = p1.location + vec
    }
}
