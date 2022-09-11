import XCTest
@testable import SimpleVerlet

final class SimpleVerletTests: XCTestCase {
    func testEngine() throws {
        let engine = PhysicsEngine()
        engine.friction = 1

        let ball1 = Point(-31, 0)
        ball1.radius = 30
        ball1.velocity.dx = 1

        let ball2 = Point(31, 0)
        ball2.radius = 30
        ball2.velocity.dx = -1

        engine.add(object: ball1)
        engine.add(object: ball2)

        engine.tick(1)

        XCTAssertEqual(ball1.location.x, -30)
        XCTAssertEqual(ball1.velocity.dx, 1)
        XCTAssertEqual(ball2.location.x, 30)
        XCTAssertEqual(ball2.velocity.dx, -1)

        engine.tick(1)

        XCTAssertEqual(ball1.location.x, -31)
        XCTAssertEqual(ball1.velocity.dx, -1)
        XCTAssertEqual(ball2.location.x, 31)
        XCTAssertEqual(ball2.velocity.dx, 1)
    }
}
