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
    private let energyType = EnergyType.base

    override func setUp() {
        super.setUp()
        manager = EntityManager()
        energySystem = EnergySystem(for: manager!)
        manager?.addEntity(GameState(maxTurns: 30))
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

        let success = energySystem.useEnergy(of: energyType, amount: 5)

        XCTAssertTrue(success)
        XCTAssertEqual(energySystem.getCurrentEnergy(of: energyType), 5)
    }

    func testUseEnergy_WithExactlyAvailableEnergy_ShouldSucceed() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        let success = energySystem.useEnergy(of: energyType, amount: 10)

        XCTAssertTrue(success)
        XCTAssertEqual(energySystem.getCurrentEnergy(of: energyType), 0)
    }

    func testUseEnergy_WithInsufficientEnergy_ShouldFail() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        guard let energyBankComponent = manager?.getSingletonComponent(ofType: EnergyBankComponent.self) else {
            XCTFail("EnergyComponent not found")
            return
        }

        energyBankComponent.setCurrentEnergy(of: energyType, to: 5)

        let success = energySystem.useEnergy(of: energyType, amount: 10)

        XCTAssertFalse(success)
        XCTAssertEqual(energyBankComponent.getCurrentEnergy(of: energyType), 5)
    }

    func testUseEnergy_WithZeroAmount_ShouldSucceed() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        let success = energySystem.useEnergy(of: energyType, amount: 0)

        XCTAssertTrue(success)
        XCTAssertEqual(energySystem.getCurrentEnergy(of: energyType), 10)
    }

    func testUseEnergy_WithNegativeAmount_ShouldFailSafely() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        let success = energySystem.useEnergy(of: energyType, amount: -5)

        XCTAssertFalse(success)
        XCTAssertEqual(energySystem.getCurrentEnergy(of: energyType), 10)
    }

    func testUseEnergy_WithNoComponents_ShouldReturnFalse() {
        let emptySystem = createEmptySystem()

        let result = emptySystem.useEnergy(of: energyType, amount: 5)

        XCTAssertFalse(result)
    }

    func testReplenishEnergy_WhenPartiallyDepleted_ShouldRestoreToMax() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        guard let energyBankComponent = manager?.getSingletonComponent(ofType: EnergyBankComponent.self) else {
            XCTFail("EnergyComponent not found")
            return
        }

        energyBankComponent.setCurrentEnergy(of: energyType, to: 3)

        energySystem.replenishEnergy(of: energyType)

        XCTAssertEqual(energyBankComponent.getCurrentEnergy(of: energyType), 10)
    }

    func testReplenishEnergy_WhenFullyDepleted_ShouldRestoreToMax() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        guard let energyBankComponent = manager?.getSingletonComponent(ofType: EnergyBankComponent.self) else {
            XCTFail("EnergyComponent not found")
            return
        }

        energyBankComponent.setCurrentEnergy(of: energyType, to: 0)

        energySystem.replenishEnergy(of: energyType)

        XCTAssertEqual(energyBankComponent.getCurrentEnergy(of: energyType), 10)
    }

    func testReplenishEnergy_WhenAlreadyFull_ShouldMaintainMax() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        energySystem.replenishEnergy(of: energyType)

        XCTAssertEqual(energySystem.getCurrentEnergy(of: energyType), 10)
    }

    func testReplenishEnergy_WithNoComponents_ShouldHandleSafely() {
        let emptySystem = createEmptySystem()

        XCTAssertNoThrow(emptySystem.replenishEnergy(of: energyType))
    }

    func testIncreaseMaxEnergy_ShouldIncreaseMaximum() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        energySystem.increaseMaxEnergy(of: energyType, by: 5)

        XCTAssertEqual(energySystem.getMaxEnergy(of: energyType), 15)
        XCTAssertEqual(energySystem.getCurrentEnergy(of: energyType), 10)
    }

    func testIncreaseMaxEnergy_WithZeroAmount_ShouldNotChange() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        energySystem.increaseMaxEnergy(of: energyType, by: 0)

        XCTAssertEqual(energySystem.getMaxEnergy(of: energyType), 10)
    }

    func testIncreaseMaxEnergy_WithNegativeAmount_ShouldHandleSafely() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        energySystem.increaseMaxEnergy(of: energyType, by: -5)

        XCTAssertEqual(energySystem.getMaxEnergy(of: energyType), 5)
    }

    func testIncreaseMaxEnergy_WithNoComponents_ShouldHandleSafely() {
        let emptySystem = createEmptySystem()

        XCTAssertNoThrow(emptySystem.increaseMaxEnergy(of: energyType, by: 5))
    }

    func testGetCurrentEnergy_ShouldReturnCorrectValue() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        guard let energyBankComponent = manager?.getSingletonComponent(ofType: EnergyBankComponent.self) else {
            XCTFail("EnergyComponent not found")
            return
        }

        energyBankComponent.setCurrentEnergy(of: energyType, to: 7)

        let currentEnergy = energySystem.getCurrentEnergy(of: energyType)

        XCTAssertEqual(currentEnergy, 7)
    }

    func testGetCurrentEnergy_WithNoComponents_ShouldReturnZero() {
        let emptySystem = createEmptySystem()

        let currentEnergy = emptySystem.getCurrentEnergy(of: energyType)

        XCTAssertEqual(currentEnergy, 0)
    }

    func testGetMaxEnergy_ShouldReturnCorrectValue() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        let maxEnergy = energySystem.getMaxEnergy(of: energyType)

        XCTAssertEqual(maxEnergy, 10)
    }

    func testGetMaxEnergy_WithNoComponents_ShouldReturnZero() {
        let emptySystem = createEmptySystem()

        let maxEnergy = emptySystem.getMaxEnergy(of: energyType)

        XCTAssertEqual(maxEnergy, 0)
    }

    func testSequentialOperations() {
        guard let setup = validateSetup() else {
            return
        }
        let (energySystem) = setup

        guard let energyBankComponent = manager?.getSingletonComponent(ofType: EnergyBankComponent.self) else {
            XCTFail("EnergyComponent not found")
            return
        }

        XCTAssertEqual(energyBankComponent.getCurrentEnergy(of: energyType), 10)
        XCTAssertEqual(energyBankComponent.getMaxEnergy(of: energyType), 10)

        XCTAssertTrue(energySystem.useEnergy(of: energyType, amount: 7))
        XCTAssertEqual(energyBankComponent.getCurrentEnergy(of: energyType), 3)

        energySystem.increaseMaxEnergy(of: energyType, by: 5)
        XCTAssertEqual(energyBankComponent.getMaxEnergy(of: energyType), 15)
        XCTAssertEqual(energyBankComponent.getCurrentEnergy(of: energyType), 3)

        energySystem.replenishEnergy(of: energyType)
        XCTAssertEqual(energyBankComponent.getCurrentEnergy(of: energyType), 15)

        XCTAssertFalse(energySystem.useEnergy(of: energyType, amount: 20))
        XCTAssertEqual(energyBankComponent.getCurrentEnergy(of: energyType), 15)

        XCTAssertTrue(energySystem.useEnergy(of: energyType, amount: 15))
        XCTAssertEqual(energyBankComponent.getCurrentEnergy(of: energyType), 0)
    }
}
