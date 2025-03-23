//
//  TurnComponentTests.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 23/3/25.
//

import XCTest
import GameplayKit
@testable import Ah_Leongs_Farm

final class TurnComponentTests: XCTestCase {

    private var turnComponent: TurnComponent?

    override func setUp() {
        super.setUp()
        turnComponent = TurnComponent(maxTurns: 10)
    }

    override func tearDown() {
        turnComponent = nil
        super.tearDown()
    }

    func testInitialization() {
        guard let component = turnComponent else {
            XCTFail("Failed to create component")
            return
        }

        XCTAssertEqual(component.currentTurn, 1)
        XCTAssertEqual(component.maxTurns, 10)
    }

    func testIncrementTurn() {
        guard let component = turnComponent else {
            XCTFail("Failed to create component")
            return
        }

        component.currentTurn += 1
        XCTAssertEqual(component.currentTurn, 2)

        component.currentTurn = 9
        component.currentTurn += 1
        XCTAssertEqual(component.currentTurn, 10)

        component.currentTurn += 1
        XCTAssertEqual(component.currentTurn, 11)
    }

    func testNegativeMaxTurns() {
        // When initializing with negative value, should use minimum value of 1
        let negativeComponent = TurnComponent(maxTurns: -5)
        XCTAssertEqual(negativeComponent.maxTurns, 1)
    }

    func testZeroMaxTurns() {
        // When initializing with zero, should use minimum value of 1
        let zeroComponent = TurnComponent(maxTurns: 0)
        XCTAssertEqual(zeroComponent.maxTurns, 1)
    }

    func testMaxTurnsUpdate() {
        guard let component = turnComponent else {
            XCTFail("Failed to create component")
            return
        }

        component.maxTurns = 15
        XCTAssertEqual(component.maxTurns, 15)

        component.maxTurns = 0
        XCTAssertEqual(component.maxTurns, 1)

        // Setting to negative should use minimum value of 1
        component.maxTurns = -3
        XCTAssertEqual(component.maxTurns, 1)
    }

    func testCurrentTurnManipulation() {
        guard let component = turnComponent else {
            XCTFail("Failed to create component")
            return
        }

        component.currentTurn = 5
        XCTAssertEqual(component.currentTurn, 5)

        // Setting to zero should use minimum value of 1
        component.currentTurn = 0
        XCTAssertEqual(component.currentTurn, 1)

        // Setting to negative should use minimum value of 1
        component.currentTurn = -2
        XCTAssertEqual(component.currentTurn, 1)

        component.currentTurn = 999
        XCTAssertEqual(component.currentTurn, 999)
    }
}
