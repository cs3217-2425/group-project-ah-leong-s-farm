//
//  EnergyComponentTests.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 23/3/25.
//

import XCTest
import Foundation
@testable import Ah_Leongs_Farm

final class EnergyBankComponentTests: XCTestCase {

    private var energyBankComponent: EnergyBankComponent!
    private let energyType = EnergyType.base

    override func setUp() {
        super.setUp()
        energyBankComponent = EnergyBankComponent(initialEnergies: [energyType: EnergyStat(current: 10, max: 10)])
    }

    override func tearDown() {
        energyBankComponent = nil
        super.tearDown()
    }

    func testInitialization() {
        guard let component = energyBankComponent else {
            XCTFail("Failed to create component")
            return
        }

        XCTAssertEqual(component.getCurrentEnergy(of: energyType), 10)
        XCTAssertEqual(component.getMaxEnergy(of: energyType), 10)
    }

    func testEnergyDepletion() {
        guard let component = energyBankComponent else {
            XCTFail("Failed to create component")
            return
        }

        component.setCurrentEnergy(of: energyType, to: 5)
        XCTAssertEqual(component.getCurrentEnergy(of: energyType), 5)

        component.setCurrentEnergy(of: energyType, to: 0)
        XCTAssertEqual(component.getCurrentEnergy(of: energyType), 0)

        component.setCurrentEnergy(of: energyType, to: -5)
        XCTAssertEqual(component.getCurrentEnergy(of: energyType), -5)
    }

    func testEnergyReplenishment() {
        guard let component = energyBankComponent else {
            XCTFail("Failed to create component")
            return
        }

        component.setCurrentEnergy(of: energyType, to: 3)
        component.setCurrentEnergy(of: energyType, to: component.getMaxEnergy(of: energyType))
        XCTAssertEqual(component.getCurrentEnergy(of: energyType), 10)

        component.setCurrentEnergy(of: energyType, to: 15)
        XCTAssertEqual(component.getCurrentEnergy(of: energyType), 15)
    }

    func testIncreaseMaxEnergy() {
        guard let component = energyBankComponent else {
            XCTFail("Failed to create component")
            return
        }

        component.increaseMaxEnergy(of: energyType, by: 5)
        XCTAssertEqual(component.getMaxEnergy(of: energyType), 15)
        XCTAssertEqual(component.getCurrentEnergy(of: energyType), 10)
    }

    func testDecreaseMaxEnergy() {
        guard let component = energyBankComponent else {
            XCTFail("Failed to create component")
            return
        }

        component.increaseMaxEnergy(of: energyType, by: -5)
        XCTAssertEqual(component.getMaxEnergy(of: energyType), 5)
        XCTAssertEqual(component.getCurrentEnergy(of: energyType), 10)
    }

    func testNegativeMaxEnergy() {
        let negativeComponent = EnergyBankComponent(initialEnergies: [.base: EnergyStat(current: -5, max: -5)])
        XCTAssertEqual(negativeComponent.getMaxEnergy(of: energyType), -5)
        XCTAssertEqual(negativeComponent.getCurrentEnergy(of: energyType), -5)
    }

    func testZeroMaxEnergy() {
        let zeroComponent = EnergyBankComponent(initialEnergies: [.base: EnergyStat(current: 0, max: 0)])
        XCTAssertEqual(zeroComponent.getMaxEnergy(of: energyType), 0)
        XCTAssertEqual(zeroComponent.getMaxEnergy(of: energyType), 0)
    }

    func testMaxEnergyWithoutAffectingCurrent() {
        guard let component = energyBankComponent else {
            XCTFail("Failed to create component")
            return
        }

        component.setCurrentEnergy(of: energyType, to: 7)
        component.increaseMaxEnergy(of: energyType, by: 5)

        XCTAssertEqual(component.getMaxEnergy(of: energyType), 15)
        XCTAssertEqual(component.getCurrentEnergy(of: energyType), 7)
    }
}
