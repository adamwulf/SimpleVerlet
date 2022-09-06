//
//  PhysicsObject+Extensions.swift
//  Example
//
//  Created by Adam Wulf on 9/6/22.
//

import Foundation
import SimpleVerlet
import UIKit

extension PhysicsObject {
    func draw() {
        switch self {
        case let p as Point:
            UIColor.blue.setStroke()
            let path = UIBezierPath(arcCenter: p.location, radius: p.radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
            path.lineWidth = 1
            path.stroke()
        case let s as Stick:
            UIColor.red.setStroke()
            let path = UIBezierPath()
            path.move(to: s.p0.location)
            path.addLine(to: s.p1.location)
            path.lineWidth = 2
            path.stroke()
        default:
            break
        }
    }
}
