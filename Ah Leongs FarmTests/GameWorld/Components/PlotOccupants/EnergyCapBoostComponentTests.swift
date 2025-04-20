//
//  EnergyCapBoostComponentTests.swift
//  Ah Leongs FarmTests
//
//  Created by Lester Ong on 20/4/25.
//

import XCTest
@testable import Ah_Leongs_Farm

final class EnergyCapBoostComponentTests: XCTestCase {
    func testInitialization() {
        let component = EnergyCapBoostComponent()

        XCTAssertNotNil(component)
        XCTAssertEqual(component.type, EnergyType.base)
        XCTAssertEqual(component.boost, 1)
    }
}
