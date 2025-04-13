//
//  GrowthComponentTests.swift
//  Ah Leongs FarmTests
//
//  Created by Lester Ong on 3/4/25.
//

import XCTest
@testable import Ah_Leongs_Farm

class GrowthComponentTests: XCTestCase {
    func testInit() {
        let growthComponent = GrowthComponent(totalGrowthTurns: 5)

        XCTAssertNotNil(growthComponent)
        XCTAssertEqual(growthComponent.totalGrowthTurns, 5)
        XCTAssertEqual(growthComponent.currentGrowthTurn, 0)
        XCTAssertFalse(growthComponent.canHarvest)
    }

    func testCanHarvest_currentGrowthTurnIsGreaterThanTotalGrowthTurns() {
        let growthComponent = GrowthComponent(totalGrowthTurns: 5)
        growthComponent.currentGrowthTurn = 6

        XCTAssertTrue(growthComponent.canHarvest)
    }

    func testCanHarvest_currentGrowthTurnIsEqualToTotalGrowthTurns() {
        let growthComponent = GrowthComponent(totalGrowthTurns: 5)
        growthComponent.currentGrowthTurn = 5

        XCTAssertTrue(growthComponent.canHarvest)
    }
}
