import XCTest
@testable import SimpleVerlet

final class SimpleVerletTests: XCTestCase {

    func testArea() throws {
        let point1 = Point(100, 100)
        point1.radius = 10

        let point2 = Point(200, 200)
        point2.area = point1.area

        XCTAssertEqual(point1.radius, point2.radius, accuracy: 0.00001)
    }

    func testApplyForce() throws {
        let point1 = Point(100, 100)
        point1.radius = 10
        point1.mass = point1.area

        XCTAssertEqual(point1.mass, 314.159265, accuracy: 0.000001)
        XCTAssertEqual(point1.velocity, .zero)

        let force = ConstantForce(CGVector(dx: 0, dy: 5))
        let duration: TimeInterval = 1
        point1.update(duration, friction: 0, forces: [force])

        XCTAssertEqual(point1.velocity.dx, 0)
        XCTAssertEqual(point1.velocity.dy, 0.01591549433, accuracy: 0.000001)
    }

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
