//
//  PositionComponentTests.swift
//  Ah Leongs FarmTests
//
//  Created by Lester Ong on 20/4/25.
//

import XCTest
@testable import Ah_Leongs_Farm

final class PositionComponentTests: XCTestCase {
    func testInitWithCoordinates() {
        let x: CGFloat = 10.5
        let y: CGFloat = 20.0
        let component = PositionComponent(x: x, y: y)

        XCTAssertNotNil(component)
        XCTAssertEqual(component.x, x)
        XCTAssertEqual(component.y, y)
    }

    func testToCGPoint() {
        let x: CGFloat = 15.0
        let y: CGFloat = 25.0
        let component = PositionComponent(x: x, y: y)

        let point = component.toCGPoint()

        XCTAssertEqual(point.x, x)
        XCTAssertEqual(point.y, y)
    }

    func testInitWithZeroCoordinates() {
        let component = PositionComponent(x: 0, y: 0)

        XCTAssertNotNil(component)
        XCTAssertEqual(component.x, 0)
        XCTAssertEqual(component.y, 0)
    }

    func testInitWithNegativeCoordinates() {
        let x: CGFloat = -10.0
        let y: CGFloat = -20.0
        let component = PositionComponent(x: x, y: y)

        XCTAssertNotNil(component)
        XCTAssertEqual(component.x, x)
        XCTAssertEqual(component.y, y)
    }
}
