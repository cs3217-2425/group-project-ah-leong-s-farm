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

    private var energySystem: EnergySystem?
    private var gameEntity: GKEntity?
    private var energyComponent: EnergyComponent?

    override func setUp() {
        super.setUp()
        energySystem = EnergySystem()
        gameEntity = GKEntity()
        energyComponent = EnergyComponent(maxEnergy: 10)

        guard let gameEntity = gameEntity, let energyComponent = energyComponent else {
            XCTFail("Failed to create entity or component")
            return
        }

        gameEntity.addComponent(energyComponent)
        energySystem?.addComponent(foundIn: gameEntity)
    }

    override func tearDown() {
        energySystem = nil
        gameEntity = nil
        energyComponent = nil
        super.tearDown()
    }

    private func validateSetup() -> (EnergySystem, GKEntity, EnergyComponent)? {
        guard let energySystem = energySystem,
              let gameEntity = gameEntity,
              let energyComponent = energyComponent else {
            XCTFail("Test setup failed: Missing system, entity, or component")
            return nil
        }
        return (energySystem, gameEntity, energyComponent)
    }

    private func createEmptySystem() -> EnergySystem {
        EnergySystem()
    }

    func testInitialization() {
        let system = EnergySystem()
        XCTAssertNotNil(system)
        XCTAssertEqual(system.components.count, 0)
    }

    func testAddComponent() {
        let system = createEmptySystem()
        let entity = GKEntity()
        let component = EnergyComponent(maxEnergy: 5)
        entity.addComponent(component)

        system.addComponent(foundIn: entity)

        XCTAssertEqual(system.components.count, 1)
        XCTAssertTrue(system.components.contains(component))
    }

    func testRemoveComponent() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem, gameEntity, _) = setup

        energySystem.removeComponent(foundIn: gameEntity)

        XCTAssertEqual(energySystem.components.count, 0)
    }

    func testUseEnergy_WithSufficientEnergy_ShouldSucceed() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem, _, energyComponent) = setup

        let success = energySystem.useEnergy(amount: 5)

        XCTAssertTrue(success)
        XCTAssertEqual(energyComponent.currentEnergy, 5)
    }

    func testUseEnergy_WithExactlyAvailableEnergy_ShouldSucceed() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem, _, energyComponent) = setup

        let success = energySystem.useEnergy(amount: 10)

        XCTAssertTrue(success)
        XCTAssertEqual(energyComponent.currentEnergy, 0)
    }

    func testUseEnergy_WithInsufficientEnergy_ShouldFail() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem, _, energyComponent) = setup

        energyComponent.currentEnergy = 5

        let success = energySystem.useEnergy(amount: 10)

        XCTAssertFalse(success)
        XCTAssertEqual(energyComponent.currentEnergy, 5)
    }

    func testUseEnergy_WithZeroAmount_ShouldSucceed() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem, _, energyComponent) = setup

        let success = energySystem.useEnergy(amount: 0)

        XCTAssertTrue(success)
        XCTAssertEqual(energyComponent.currentEnergy, 10)
    }

    func testUseEnergy_WithNegativeAmount_ShouldFailSafely() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem, _, energyComponent) = setup

        let success = energySystem.useEnergy(amount: -5)

        XCTAssertFalse(success)
        XCTAssertEqual(energyComponent.currentEnergy, 10)
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
        let (energySystem, _, energyComponent) = setup

        energyComponent.currentEnergy = 3

        energySystem.replenishEnergy()

        XCTAssertEqual(energyComponent.currentEnergy, 10)
    }

    func testReplenishEnergy_WhenFullyDepleted_ShouldRestoreToMax() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem, _, energyComponent) = setup

        energyComponent.currentEnergy = 0

        energySystem.replenishEnergy()

        XCTAssertEqual(energyComponent.currentEnergy, 10)
    }

    func testReplenishEnergy_WhenAlreadyFull_ShouldMaintainMax() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem, _, energyComponent) = setup

        energySystem.replenishEnergy()

        XCTAssertEqual(energyComponent.currentEnergy, 10)
    }

    func testReplenishEnergy_WithNoComponents_ShouldHandleSafely() {
        let emptySystem = createEmptySystem()

        XCTAssertNoThrow(emptySystem.replenishEnergy())
    }

    func testIncreaseMaxEnergy_ShouldIncreaseMaximum() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem, _, energyComponent) = setup

        energySystem.increaseMaxEnergy(by: 5)

        XCTAssertEqual(energyComponent.maxEnergy, 15)
        XCTAssertEqual(energyComponent.currentEnergy, 10)
    }

    func testIncreaseMaxEnergy_WithZeroAmount_ShouldNotChange() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem, _, energyComponent) = setup

        energySystem.increaseMaxEnergy(by: 0)

        XCTAssertEqual(energyComponent.maxEnergy, 10)
    }

    func testIncreaseMaxEnergy_WithNegativeAmount_ShouldHandleSafely() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem, _, energyComponent) = setup

        energySystem.increaseMaxEnergy(by: -5)

        XCTAssertEqual(energyComponent.maxEnergy, 5)
    }

    func testIncreaseMaxEnergy_WithNoComponents_ShouldHandleSafely() {
        let emptySystem = createEmptySystem()

        XCTAssertNoThrow(emptySystem.increaseMaxEnergy(by: 5))
    }

    func testGetCurrentEnergy_ShouldReturnCorrectValue() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem, _, energyComponent) = setup

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
        let (energySystem, _, _) = setup

        let maxEnergy = energySystem.getMaxEnergy()

        XCTAssertEqual(maxEnergy, 10)
    }

    func testGetMaxEnergy_WithNoComponents_ShouldReturnZero() {
        let emptySystem = createEmptySystem()

        let maxEnergy = emptySystem.getMaxEnergy()

        XCTAssertEqual(maxEnergy, 0)
    }

    func testMultipleComponentsSupport() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem, _, _) = setup

        let secondEntity = GKEntity()
        let secondComponent = EnergyComponent(maxEnergy: 20)
        secondEntity.addComponent(secondComponent)
        energySystem.addComponent(foundIn: secondEntity)

        XCTAssertEqual(energySystem.components.count, 2)

        let currentEnergy = energySystem.getCurrentEnergy()
        let maxEnergy = energySystem.getMaxEnergy()

        XCTAssertEqual(currentEnergy, 10)
        XCTAssertEqual(maxEnergy, 10)
    }

    func testSequentialOperations() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem, _, energyComponent) = setup

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
