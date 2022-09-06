//
//  PhysicsView.swift
//  Example
//
//  Created by Adam Wulf on 9/6/22.
//

import Foundation
import UIKit
import SimpleVerlet

class PhysicsView: UIView {

    var engine: PhysicsEngine?

    override func draw(_ rect: CGRect) {
        guard let engine = engine else { return }

        for object in engine.objects {
            object.draw()
        }
    }
}
