//
//  TurnSystemTests.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 23/3/25.
//

import XCTest
import GameplayKit
@testable import Ah_Leongs_Farm

final class TurnSystemTests: XCTestCase {

    private var turnSystem: TurnSystem?
    private var gameEntity: GKEntity?
    private var turnComponent: TurnComponent?

    override func setUp() {
        super.setUp()
        turnSystem = TurnSystem()
        gameEntity = GKEntity()
        turnComponent = TurnComponent(maxTurns: 10)

        guard let gameEntity = gameEntity, let turnComponent = turnComponent else {
            XCTFail("Failed to create entity or component")
            return
        }

        gameEntity.addComponent(turnComponent)
        turnSystem?.addComponent(foundIn: gameEntity)
    }

    override func tearDown() {
        turnSystem = nil
        gameEntity = nil
        turnComponent = nil
        super.tearDown()
    }

    private func validateSetup() -> (TurnSystem, GKEntity, TurnComponent)? {
        guard let turnSystem = turnSystem,
              let gameEntity = gameEntity,
              let turnComponent = turnComponent else {
            XCTFail("Test setup failed: Missing system, entity, or component")
            return nil
        }
        return (turnSystem, gameEntity, turnComponent)
    }

    private func createEmptySystem() -> TurnSystem {
        TurnSystem()
    }

    func testInitialization() {
        let system = TurnSystem()
        XCTAssertNotNil(system)
        XCTAssertEqual(system.components.count, 0)
    }

    func testAddComponent() {
        let system = createEmptySystem()
        let entity = GKEntity()
        let component = TurnComponent(maxTurns: 5)
        entity.addComponent(component)

        system.addComponent(foundIn: entity)

        XCTAssertEqual(system.components.count, 1)
        XCTAssertTrue(system.components.contains(component))
    }

    func testRemoveComponent() {
        guard let setup = validateSetup() else {
            return
        }
        let (turnSystem, gameEntity, _) = setup

        turnSystem.removeComponent(foundIn: gameEntity)

        XCTAssertEqual(turnSystem.components.count, 0)
    }

    func testIncrementTurn_WhenBelowMaxTurns_ShouldIncrementAndReturnTrue() {
        guard let setup = validateSetup() else {
            return
        }
        let (turnSystem, _, turnComponent) = setup

        let shouldContinue = turnSystem.incrementTurn()

        XCTAssertTrue(shouldContinue)
        XCTAssertEqual(turnComponent.currentTurn, 2)
    }

    func testIncrementTurn_WhenAtMaxTurns_ShouldIncrementAndReturnFalse() {
        guard let setup = validateSetup() else {
            return
        }
        let (turnSystem, _, turnComponent) = setup

        turnComponent.currentTurn = 10

        let shouldContinue = turnSystem.incrementTurn()

        XCTAssertFalse(shouldContinue)
        XCTAssertEqual(turnComponent.currentTurn, 11)
    }

    func testIncrementTurn_WhenMultipleTimes_ShouldTrackCorrectly() {
        guard let setup = validateSetup() else {
            return
        }
        let (turnSystem, _, turnComponent) = setup

        XCTAssertTrue(turnSystem.incrementTurn())
        XCTAssertEqual(turnComponent.currentTurn, 2)

        XCTAssertTrue(turnSystem.incrementTurn())
        XCTAssertEqual(turnComponent.currentTurn, 3)

        turnComponent.currentTurn = 9
        XCTAssertTrue(turnSystem.incrementTurn())
        XCTAssertEqual(turnComponent.currentTurn, 10)

        XCTAssertFalse(turnSystem.incrementTurn())
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
        let (turnSystem, _, turnComponent) = setup

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
        let (turnSystem, _, _) = setup

        let maxTurns = turnSystem.getMaxTurns()

        XCTAssertEqual(maxTurns, 10)
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
        let (turnSystem, _, turnComponent) = setup

        turnComponent.currentTurn = 5

        let isGameOver = turnSystem.isGameOver()

        XCTAssertFalse(isGameOver)
    }

    func testIsGameOver_WhenAtMaxTurns_ShouldReturnFalse() {
        guard let setup = validateSetup() else {
            return
        }
        let (turnSystem, _, turnComponent) = setup

        turnComponent.currentTurn = 10

        let isGameOver = turnSystem.isGameOver()

        XCTAssertFalse(isGameOver)
    }

    func testIsGameOver_WhenExceedingMaxTurns_ShouldReturnTrue() {
        guard let setup = validateSetup() else {
            return
        }
        let (turnSystem, _, turnComponent) = setup

        turnComponent.currentTurn = 11

        let isGameOver = turnSystem.isGameOver()

        XCTAssertTrue(isGameOver)
    }

    func testIsGameOver_WithNoComponents_ShouldReturnTrue() {
        let emptySystem = createEmptySystem()

        let isGameOver = emptySystem.isGameOver()

        XCTAssertTrue(isGameOver)
    }

    func testMultipleComponentsSupport() {
        guard let setup = validateSetup() else {
            return
        }
        let (turnSystem, _, _) = setup

        let secondEntity = GKEntity()
        let secondComponent = TurnComponent(maxTurns: 20)
        secondEntity.addComponent(secondComponent)
        turnSystem.addComponent(foundIn: secondEntity)

        XCTAssertEqual(turnSystem.components.count, 2)

        let currentTurn = turnSystem.getCurrentTurn()
        let maxTurns = turnSystem.getMaxTurns()

        XCTAssertEqual(currentTurn, 1)
        XCTAssertEqual(maxTurns, 10)
    }
}
