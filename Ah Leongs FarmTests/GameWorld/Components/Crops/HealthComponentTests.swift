//
//  HealthComponentTests.swift
//  Ah Leongs FarmTests
//
//  Created by Lester Ong on 3/4/25.
//

import XCTest
@testable import Ah_Leongs_Farm

class HealthComponentTests: XCTestCase {
    func testInit() {
        let healthComponent = HealthComponent()

        XCTAssertNotNil(healthComponent)
        XCTAssertEqual(healthComponent.health, 1.0)
        XCTAssertEqual(healthComponent.maxHealth, 1.0)
    }
}
