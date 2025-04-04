//
//  LevelSystemTests.swift
//  Ah Leongs Farm
//
//  Created by proglab on 22/3/25.
//

import XCTest
import GameplayKit

@testable import Ah_Leongs_Farm

class LevelSystemTests: XCTestCase {
    var levelSystem: LevelSystem!
    var manager: EntityManager!

    override func setUp() {
        super.setUp()
        manager = EntityManager()
        levelSystem = LevelSystem(for: manager)
        manager.addEntity(GameState(maxTurns: 30, maxEnergy: 10))
    }

    override func tearDown() {
        levelSystem = nil
        manager = nil
        super.tearDown()
    }

    func testInitialLevel() {
        XCTAssertEqual(levelSystem.getCurrentLevel(), 1, "Initial level should be 1")
        XCTAssertEqual(levelSystem.getCurrentXP(), 0, "Initial XP should be 0")
    }

    func testAddXPWithoutLevelUp() {
        levelSystem.addXP(50)
        XCTAssertEqual(levelSystem.getCurrentXP(), 50, "XP should be updated correctly")
        XCTAssertEqual(levelSystem.getCurrentLevel(), 1, "Level should remain the same")
    }

    func testAddXPWithLevelUp() {
        levelSystem.addXP(150)
        XCTAssertEqual(levelSystem.getCurrentLevel(), 2, "Level should be increased")
        XCTAssertEqual(levelSystem.getCurrentXP(), 50, "Remaining XP should carry over")
    }

    func testAddXPThresholdHolds() {
        levelSystem.addXP(250)
        XCTAssertEqual(levelSystem.getCurrentLevel(), 2, "Should remain in level 2")
        XCTAssertEqual(levelSystem.getCurrentXP(), 150, "Should carry over 150 XP over")
    }

    func testAddXPMultipleLevelUps() {
        levelSystem.addXP(350)
        XCTAssertEqual(levelSystem.getCurrentLevel(), 3, "Should level up to 3")
        XCTAssertEqual(levelSystem.getCurrentXP(), 50, "Should carry over 50 XP over")
    }

    func testGetXPForNextLevel() {
        XCTAssertEqual(levelSystem.getXPForNextLevel(), 200)
    }

    func testGetXPProgress() {
        levelSystem.addXP(50)
        XCTAssertEqual(levelSystem.getXPProgress(), 0.5)
    }
}
