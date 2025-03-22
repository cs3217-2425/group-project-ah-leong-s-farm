//
//  EnergyComponentTests.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 23/3/25.
//

import XCTest
import GameplayKit
@testable import Ah_Leongs_Farm

final class EnergyComponentTests: XCTestCase {

    private var energyComponent: EnergyComponent?

    override func setUp() {
        super.setUp()
        energyComponent = EnergyComponent(maxEnergy: 10)
    }

    override func tearDown() {
        energyComponent = nil
        super.tearDown()
    }

    func testInitialization() {
        guard let component = energyComponent else {
            XCTFail("Failed to create component")
            return
        }

        XCTAssertEqual(component.currentEnergy, 10)
        XCTAssertEqual(component.maxEnergy, 10)
    }

    func testEnergyDepletion() {
        guard let component = energyComponent else {
            XCTFail("Failed to create component")
            return
        }

        component.currentEnergy -= 5
        XCTAssertEqual(component.currentEnergy, 5)

        component.currentEnergy = 0
        XCTAssertEqual(component.currentEnergy, 0)

        component.currentEnergy -= 5
        XCTAssertEqual(component.currentEnergy, -5)
    }

    func testEnergyReplenishment() {
        guard let component = energyComponent else {
            XCTFail("Failed to create component")
            return
        }

        component.currentEnergy = 3
        component.currentEnergy = component.maxEnergy
        XCTAssertEqual(component.currentEnergy, 10)

        component.currentEnergy += 5
        XCTAssertEqual(component.currentEnergy, 15)
    }

    func testIncreaseMaxEnergy() {
        guard let component = energyComponent else {
            XCTFail("Failed to create component")
            return
        }

        component.maxEnergy += 5
        XCTAssertEqual(component.maxEnergy, 15)
        XCTAssertEqual(component.currentEnergy, 10)
    }

    func testDecreaseMaxEnergy() {
        guard let component = energyComponent else {
            XCTFail("Failed to create component")
            return
        }

        component.maxEnergy -= 5
        XCTAssertEqual(component.maxEnergy, 5)
        XCTAssertEqual(component.currentEnergy, 10)
    }

    func testNegativeMaxEnergy() {
        let negativeComponent = EnergyComponent(maxEnergy: -5)
        XCTAssertEqual(negativeComponent.maxEnergy, -5)
        XCTAssertEqual(negativeComponent.currentEnergy, -5)
    }

    func testZeroMaxEnergy() {
        let zeroComponent = EnergyComponent(maxEnergy: 0)
        XCTAssertEqual(zeroComponent.maxEnergy, 0)
        XCTAssertEqual(zeroComponent.currentEnergy, 0)
    }

    func testMaxEnergyWithoutAffectingCurrent() {
        guard let component = energyComponent else {
            XCTFail("Failed to create component")
            return
        }

        component.currentEnergy = 7
        component.maxEnergy = 15

        XCTAssertEqual(component.maxEnergy, 15)
        XCTAssertEqual(component.currentEnergy, 7)
    }

    func testBoundaryConditions() {
        guard let component = energyComponent else {
            XCTFail("Failed to create component")
            return
        }

        component.currentEnergy = Int.max
        XCTAssertEqual(component.currentEnergy, Int.max)

        component.currentEnergy = Int.min
        XCTAssertEqual(component.currentEnergy, Int.min)

        component.maxEnergy = Int.max
        XCTAssertEqual(component.maxEnergy, Int.max)
    }
}
