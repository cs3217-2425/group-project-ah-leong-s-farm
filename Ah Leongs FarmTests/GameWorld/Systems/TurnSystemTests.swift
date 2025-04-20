//
//  TurnSystemTests.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 23/3/25.
//

import XCTest
@testable import Ah_Leongs_Farm

final class TurnSystemTests: XCTestCase {

    var turnSystem: TurnSystem?
    var manager: EntityManager?

    override func setUp() {
        super.setUp()
        manager = EntityManager()
        turnSystem = TurnSystem(for: manager!)
        manager?.addEntity(GameState(maxTurns: 30))
    }

    override func tearDown() {
        turnSystem = nil
        manager = nil
        super.tearDown()
    }

    private func validateSetup() -> TurnSystem? {
        guard let system = turnSystem else {
            XCTFail("Test setup failed: Missing system, entity, or component")
            return nil
        }
        return system
    }

    private func createEmptySystem() -> TurnSystem {
        manager = EntityManager()
        return TurnSystem(for: manager!)
    }

    func testInitialization() {
        let system = TurnSystem(for: EntityManager())
        XCTAssertNotNil(system)
    }

    func testIncrementTurn_WhenBelowMaxTurns_ShouldIncrementAndReturnTrue() {
        guard let setup = validateSetup() else {
            return
        }
        let (turnSystem) = setup

        let shouldContinue = turnSystem.incrementTurn()

        XCTAssertTrue(shouldContinue)
        XCTAssertEqual(turnSystem.getCurrentTurn(), 2)
    }

    func testIncrementTurn_WhenAtMaxTurns_ShouldIncrementAndReturnFalse() {
        guard let setup = validateSetup() else {
            return
        }
        let (turnSystem) = setup

        guard let turnComponent = manager?.getSingletonComponent(ofType: TurnComponent.self) else {
            XCTFail("TurnComponent not found")
            return
        }

        turnComponent.currentTurn = 30

        let shouldContinue = turnSystem.incrementTurn()

        XCTAssertFalse(shouldContinue)
        XCTAssertEqual(turnComponent.currentTurn, 31)
    }

    func testIncrementTurn_WhenMultipleTimes_ShouldTrackCorrectly() {
        guard let setup = validateSetup() else {
            return
        }
        let (turnSystem) = setup

        guard let turnComponent = manager?.getSingletonComponent(ofType: TurnComponent.self) else {
            XCTFail("TurnComponent not found")
            return
        }

        XCTAssertTrue(turnSystem.incrementTurn())
        XCTAssertEqual(turnComponent.currentTurn, 2)

        XCTAssertTrue(turnSystem.incrementTurn())
        XCTAssertEqual(turnComponent.currentTurn, 3)

        turnComponent.currentTurn = 9
        XCTAssertTrue(turnSystem.incrementTurn())
        XCTAssertEqual(turnComponent.currentTurn, 10)

        XCTAssertTrue(turnSystem.incrementTurn())
        XCTAssertEqual(turnComponent.currentTurn, 11)
    }

    func testIncrementTurn_WithNoComponents_ShouldReturnFalse() {
        let emptySystem = createEmptySystem()

        let result = emptySystem.incrementTurn()

        XCTAssertFalse(result)
    }

    func testGetCurrentTurn_ShouldReturnCorrectValue() {
        guard let setup = validateSetup() else {
            return
        }
        let (turnSystem) = setup

        guard let turnComponent = manager?.getSingletonComponent(ofType: TurnComponent.self) else {
            XCTFail("TurnComponent not found")
            return
        }

        turnComponent.currentTurn = 5

        let currentTurn = turnSystem.getCurrentTurn()

        XCTAssertEqual(currentTurn, 5)
    }

    func testGetCurrentTurn_WithNoComponents_ShouldReturnOne() {
        let emptySystem = createEmptySystem()

        let currentTurn = emptySystem.getCurrentTurn()

        XCTAssertEqual(currentTurn, 1)
    }

    func testGetMaxTurns_ShouldReturnCorrectValue() {
        guard let setup = validateSetup() else {
            return
        }
        let (turnSystem) = setup

        let maxTurns = turnSystem.getMaxTurns()

        XCTAssertEqual(maxTurns, 30)
    }

    func testGetMaxTurns_WithNoComponents_ShouldReturnOne() {
        let emptySystem = createEmptySystem()

        let maxTurns = emptySystem.getMaxTurns()

        XCTAssertEqual(maxTurns, 1)
    }

    func testIsGameOver_WhenUnderMaxTurns_ShouldReturnFalse() {
        guard let setup = validateSetup() else {
            return
        }
        let (turnSystem) = setup

        guard let turnComponent = manager?.getSingletonComponent(ofType: TurnComponent.self) else {
            XCTFail("TurnComponent not found")
            return
        }

        turnComponent.currentTurn = 5

        let isGameOver = turnSystem.isGameOver()

        XCTAssertFalse(isGameOver)
    }

    func testIsGameOver_WhenAtMaxTurns_ShouldReturnFalse() {
        guard let setup = validateSetup() else {
            return
        }
        let (turnSystem) = setup

        guard let turnComponent = manager?.getSingletonComponent(ofType: TurnComponent.self) else {
            XCTFail("TurnComponent not found")
            return
        }

        turnComponent.currentTurn = 10

        let isGameOver = turnSystem.isGameOver()

        XCTAssertFalse(isGameOver)
    }

    func testIsGameOver_WhenExceedingMaxTurns_ShouldReturnTrue() {
        guard let setup = validateSetup() else {
            return
        }
        let (turnSystem) = setup

        guard let turnComponent = manager?.getSingletonComponent(ofType: TurnComponent.self) else {
            XCTFail("TurnComponent not found")
            return
        }

        turnComponent.currentTurn = 31

        let isGameOver = turnSystem.isGameOver()

        XCTAssertTrue(isGameOver)
    }

    func testIsGameOver_WithNoComponents_ShouldReturnTrue() {
        let emptySystem = createEmptySystem()

        let isGameOver = emptySystem.isGameOver()

        XCTAssertTrue(isGameOver)
    }
}
