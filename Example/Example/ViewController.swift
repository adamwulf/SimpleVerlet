//
//  ViewController.swift
//  Example
//
//  Created by Adam Wulf on 9/6/22.
//

import UIKit
import SimpleVerlet
import SwiftToolbox

class ViewController: UIViewController {

    private let engine = PhysicsEngine()

    var displayLink: CADisplayLink!

    var ball: Point!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        engine.friction = 0.999
        engine.box = CGRect(0, 0, 500, 500)
        engine.add(force: PhysicsForce.gravity)

//        for _ in 0..<10 {
//            let ball = Point(CGPoint(CGFloat.random(in: 0..<200), CGFloat.random(in: 0..<200)))
//            ball.radius = CGFloat.random(in: 10..<60)
//            ball.velocity = CGVector(CGFloat.random(in: -10...10), CGFloat.random(in: -10...10))
//            engine.add(object: ball)
//        }

        ball = Point(CGPoint(100, 40))
        ball.radius = 30
        ball.velocity = CGVector(0.5, 0)
        engine.add(object: ball)

        let other = Point(CGPoint(200, 40))
        other.radius = 30
        other.velocity = CGVector(-0.5, 0)
        engine.add(object: other)

//        engine.add(object: Stick(p0: CGPoint(30, 50), p1: CGPoint(120, 80)))
//        engine.add(object: Stick(p0: CGPoint(100, 20), p1: CGPoint(90, 60)))
//        engine.add(object: Stick(p0: CGPoint(300, 20), p1: CGPoint(301, 80)))
//        engine.add(object: Stick(p0: CGPoint(75, 120), p1: CGPoint(301, 255)))

        displayLink = CADisplayLink(target: self, selector: #selector(tick))
        displayLink.preferredFrameRateRange = CAFrameRateRange(minimum: 30, maximum: 60)
        displayLink.add(to: .current, forMode: .default)

        (view as? PhysicsView)?.engine = engine
        view.setNeedsDisplay()
    }

    @objc func tick() {
        let epsilon = displayLink.targetTimestamp - displayLink.timestamp

        engine.tick(epsilon)

        view.setNeedsDisplay()
    }
}
