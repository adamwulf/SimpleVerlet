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
        let point = Point(100, 100)
        point.radius = 10
        point.mass = point.area

        XCTAssertEqual(point.mass, 314.159265, accuracy: 0.000001)
        XCTAssertEqual(point.velocity, .zero)

        let force = ConstantForce(CGVector(dx: 0, dy: 5))
        let duration: TimeInterval = 1
        point.update(duration, friction: 0, forces: [force])

        XCTAssertEqual(point.velocity.dx, 0)
        XCTAssertEqual(point.velocity.dy, 0.01591549433, accuracy: 0.000001)
    }

    func testBounceOnBox() throws {
        let point = Point(11, 11)
        point.radius = 10
        point.mass = point.area
        point.velocity = CGVector(-1, -1)

        let engine = PhysicsEngine()
        engine.box = CGRect(0, 0, 100, 100)
        engine.add(object: point)

        engine.tick(1)

        XCTAssertEqual(point.location, CGPoint(10, 10))
        XCTAssertEqual(point.velocity, CGVector(-1, -1))

        engine.tick(1)

        XCTAssertEqual(point.location, CGPoint(11, 11))
        XCTAssertEqual(point.velocity, CGVector(1, 1))

    }

    func testFractionalBounceOnBox() throws {
        let point = Point(11.5, 11.5)
        point.radius = 10
        point.mass = point.area
        point.velocity = CGVector(-1, -1)

        let engine = PhysicsEngine()
        engine.box = CGRect(0, 0, 100, 100)
        engine.add(object: point)

        engine.tick(1)

        XCTAssertEqual(point.location, CGPoint(10.5, 10.5))
        XCTAssertEqual(point.velocity, CGVector(-1, -1))

        engine.tick(1)

        XCTAssertEqual(point.location, CGPoint(10.5, 10.5))
        XCTAssertEqual(point.velocity, CGVector(1, 1))

    }

    // elastic collision example from https://www.problemsphysics.com/momentum/collisions.html
    func testEngine() throws {
        let engine = PhysicsEngine()

        let ball1 = Point(0, 0)
        ball1.radius = 30
        ball1.mass = 0.1
        ball1.velocity.dx = 10

        let ball2 = Point(65, 0)
        ball2.radius = 30
        ball2.mass = 0.2
        ball2.velocity.dx = 5

        engine.add(object: ball1)
        engine.add(object: ball2)

        XCTAssertEqual(ball1.momentum, 1)
        XCTAssertEqual(ball2.momentum, 1)
        XCTAssertEqual(ball1.kineticEnergy, 5)
        XCTAssertEqual(ball2.kineticEnergy, 2.5)

        engine.tick(1)

        XCTAssertEqual(ball1.location.x, -30)
        XCTAssertEqual(ball1.velocity.dx, 1)
        XCTAssertEqual(ball2.location.x, 30)
        XCTAssertEqual(ball2.velocity.dx, -1)

        XCTAssertEqual(ball1.momentum, -1)

        engine.tick(1)

        XCTAssertEqual(ball1.location.x, -31)
        XCTAssertEqual(ball1.velocity.dx, -1)
        XCTAssertEqual(ball2.location.x, 31)
        XCTAssertEqual(ball2.velocity.dx, 1)
    }
}
