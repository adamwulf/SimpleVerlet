//
//  ViewController.swift
//  Example
//
//  Created by Adam Wulf on 9/6/22.
//

import UIKit
import SimpleVerlet

class ViewController: UIViewController {

    private let engine = PhysicsEngine()

    var balls: [PhysicsObject] = []
    var displayLink: CADisplayLink!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        engine.add(force: PhysicsForce.gravity)

        for _ in 0..<10 {
            let ball = Point(CGPoint(CGFloat.random(in: 0..<200), CGFloat.random(in: 0..<200)))
            ball.radius = CGFloat.random(in: 10..<60)
            engine.add(object: ball)
        }

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
