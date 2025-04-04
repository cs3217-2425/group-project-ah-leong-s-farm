//
//  EnergySystemTests.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 23/3/25.
//

import XCTest
import GameplayKit
@testable import Ah_Leongs_Farm

final class EnergySystemTests: XCTestCase {

    var energySystem: EnergySystem?
    var manager: EntityManager?

    override func setUp() {
        super.setUp()
        manager = EntityManager()
        energySystem = EnergySystem(for: manager!)
        manager?.addEntity(GameState(maxTurns: 30, maxEnergy: 10))
    }

    override func tearDown() {
        energySystem = nil
        super.tearDown()
    }

    private func validateSetup() -> (EnergySystem)? {
        guard let energySystem = energySystem else {
            XCTFail("Test setup failed: Missing system, entity, or component")
            return nil
        }
        return (energySystem)
    }

    private func createEmptySystem() -> EnergySystem {
        manager = EntityManager()
        return EnergySystem(for: manager!)
    }

    func testInitialization() {
        let system = EnergySystem(for: EntityManager())
        XCTAssertNotNil(system)
    }

    func testUseEnergy_WithSufficientEnergy_ShouldSucceed() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        let success = energySystem.useEnergy(amount: 5)

        XCTAssertTrue(success)
        XCTAssertEqual(energySystem.getCurrentEnergy(), 5)
    }

    func testUseEnergy_WithExactlyAvailableEnergy_ShouldSucceed() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        let success = energySystem.useEnergy(amount: 10)

        XCTAssertTrue(success)
        XCTAssertEqual(energySystem.getCurrentEnergy(), 0)
    }

    func testUseEnergy_WithInsufficientEnergy_ShouldFail() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        guard let energyComponent = manager?.getSingletonComponent(ofType: EnergyComponent.self) else {
            XCTFail("EnergyComponent not found")
            return
        }

        energyComponent.currentEnergy = 5

        let success = energySystem.useEnergy(amount: 10)

        XCTAssertFalse(success)
        XCTAssertEqual(energyComponent.currentEnergy, 5)
    }

    func testUseEnergy_WithZeroAmount_ShouldSucceed() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        let success = energySystem.useEnergy(amount: 0)

        XCTAssertTrue(success)
        XCTAssertEqual(energySystem.getCurrentEnergy(), 10)
    }

    func testUseEnergy_WithNegativeAmount_ShouldFailSafely() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        let success = energySystem.useEnergy(amount: -5)

        XCTAssertFalse(success)
        XCTAssertEqual(energySystem.getCurrentEnergy(), 10)
    }

    func testUseEnergy_WithNoComponents_ShouldReturnFalse() {
        let emptySystem = createEmptySystem()

        let result = emptySystem.useEnergy(amount: 5)

        XCTAssertFalse(result)
    }

    func testReplenishEnergy_WhenPartiallyDepleted_ShouldRestoreToMax() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        guard let energyComponent = manager?.getSingletonComponent(ofType: EnergyComponent.self) else {
            XCTFail("EnergyComponent not found")
            return
        }

        energyComponent.currentEnergy = 3

        energySystem.replenishEnergy()

        XCTAssertEqual(energyComponent.currentEnergy, 10)
    }

    func testReplenishEnergy_WhenFullyDepleted_ShouldRestoreToMax() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        guard let energyComponent = manager?.getSingletonComponent(ofType: EnergyComponent.self) else {
            XCTFail("EnergyComponent not found")
            return
        }

        energyComponent.currentEnergy = 0

        energySystem.replenishEnergy()

        XCTAssertEqual(energyComponent.currentEnergy, 10)
    }

    func testReplenishEnergy_WhenAlreadyFull_ShouldMaintainMax() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        energySystem.replenishEnergy()

        XCTAssertEqual(energySystem.getCurrentEnergy(), 10)
    }

    func testReplenishEnergy_WithNoComponents_ShouldHandleSafely() {
        let emptySystem = createEmptySystem()

        XCTAssertNoThrow(emptySystem.replenishEnergy())
    }

    func testIncreaseMaxEnergy_ShouldIncreaseMaximum() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        energySystem.increaseMaxEnergy(by: 5)

        XCTAssertEqual(energySystem.getMaxEnergy(), 15)
        XCTAssertEqual(energySystem.getCurrentEnergy(), 10)
    }

    func testIncreaseMaxEnergy_WithZeroAmount_ShouldNotChange() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        energySystem.increaseMaxEnergy(by: 0)

        XCTAssertEqual(energySystem.getMaxEnergy(), 10)
    }

    func testIncreaseMaxEnergy_WithNegativeAmount_ShouldHandleSafely() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        energySystem.increaseMaxEnergy(by: -5)

        XCTAssertEqual(energySystem.getMaxEnergy(), 5)
    }

    func testIncreaseMaxEnergy_WithNoComponents_ShouldHandleSafely() {
        let emptySystem = createEmptySystem()

        XCTAssertNoThrow(emptySystem.increaseMaxEnergy(by: 5))
    }

    func testGetCurrentEnergy_ShouldReturnCorrectValue() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        guard let energyComponent = manager?.getSingletonComponent(ofType: EnergyComponent.self) else {
            XCTFail("EnergyComponent not found")
            return
        }

        energyComponent.currentEnergy = 7

        let currentEnergy = energySystem.getCurrentEnergy()

        XCTAssertEqual(currentEnergy, 7)
    }

    func testGetCurrentEnergy_WithNoComponents_ShouldReturnZero() {
        let emptySystem = createEmptySystem()

        let currentEnergy = emptySystem.getCurrentEnergy()

        XCTAssertEqual(currentEnergy, 0)
    }

    func testGetMaxEnergy_ShouldReturnCorrectValue() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        let maxEnergy = energySystem.getMaxEnergy()

        XCTAssertEqual(maxEnergy, 10)
    }

    func testGetMaxEnergy_WithNoComponents_ShouldReturnZero() {
        let emptySystem = createEmptySystem()

        let maxEnergy = emptySystem.getMaxEnergy()

        XCTAssertEqual(maxEnergy, 0)
    }

    func testSequentialOperations() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        guard let energyComponent = manager?.getSingletonComponent(ofType: EnergyComponent.self) else {
            XCTFail("EnergyComponent not found")
            return
        }

        XCTAssertEqual(energyComponent.currentEnergy, 10)
        XCTAssertEqual(energyComponent.maxEnergy, 10)

        XCTAssertTrue(energySystem.useEnergy(amount: 7))
        XCTAssertEqual(energyComponent.currentEnergy, 3)

        energySystem.increaseMaxEnergy(by: 5)
        XCTAssertEqual(energyComponent.maxEnergy, 15)
        XCTAssertEqual(energyComponent.currentEnergy, 3)

        energySystem.replenishEnergy()
        XCTAssertEqual(energyComponent.currentEnergy, 15)

        XCTAssertFalse(energySystem.useEnergy(amount: 20))
        XCTAssertEqual(energyComponent.currentEnergy, 15)

        XCTAssertTrue(energySystem.useEnergy(amount: 15))
        XCTAssertEqual(energyComponent.currentEnergy, 0)
    }
}
