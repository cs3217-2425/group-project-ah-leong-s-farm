//
//  HarvestedComponentTests.swift
//  Ah Leongs FarmTests
//
//  Created by Lester Ong on 3/4/25.
//

import XCTest
@testable import Ah_Leongs_Farm

class HarvestedComponentTests: XCTestCase {
    func testInit() {
        let harvestedComponent = HarvestedComponent()
        XCTAssertNotNil(harvestedComponent)
    }
}
