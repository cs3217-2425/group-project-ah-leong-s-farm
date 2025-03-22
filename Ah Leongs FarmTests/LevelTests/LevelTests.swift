//
//  LevelTests.swift
//  Ah Leongs Farm
//
//  Created by proglab on 22/3/25.
//

import XCTest
@testable import Ah_Leongs_Farm

class LevelTests: XCTestCase {

    func testInitialization() throws {

        let level = Level()

        guard let levelComponent = level.component(ofType: LevelComponent.self) else {
            XCTFail("Expected a LevelComponent to be added to the Level entity")
            return
        }

        XCTAssertEqual(levelComponent.level, 1)
        XCTAssertEqual(levelComponent.currentXP, 0)
    }
}
