//
//  SeedComponentTests.swift
//  Ah Leongs FarmTests
//
//  Created by Lester Ong on 3/4/25.
//

import XCTest
@testable import Ah_Leongs_Farm

class SeedComponentTests: XCTestCase {
    func testInit() {
        let seedComponent = SeedComponent()

        XCTAssertNotNil(seedComponent)
    }
}
