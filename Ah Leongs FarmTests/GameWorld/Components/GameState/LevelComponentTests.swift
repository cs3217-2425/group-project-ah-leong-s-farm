//
//  LevelComponentTests.swift
//  Ah Leongs Farm
//
//  Created by proglab on 22/3/25.
//

import XCTest
import GameplayKit

@testable import Ah_Leongs_Farm

class LevelComponentTests: XCTestCase {

    func testInitialization() {
        let levelComponent = LevelComponent(level: 1, currentXP: 0)
        XCTAssertEqual(levelComponent.level, 1)
        XCTAssertEqual(levelComponent.currentXP, 0)
        XCTAssertEqual(levelComponent.thresholdXP, 100)
    }

    func testXPThresholdCalculation() {
        XCTAssertEqual(LevelComponent.calculateXPThreshold(for: 1), 100)
        XCTAssertEqual(LevelComponent.calculateXPThreshold(for: 5), 500)
        XCTAssertEqual(LevelComponent.calculateXPThreshold(for: 10), 1_000)
    }

    func testSetLevel() {
        let levelComponent = LevelComponent(level: 2, currentXP: 50)
        levelComponent.setLevel(3, xp: 120)

        XCTAssertEqual(levelComponent.level, 3)
        XCTAssertEqual(levelComponent.currentXP, 120)
        XCTAssertEqual(levelComponent.thresholdXP, 300)
    }
}
