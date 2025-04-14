//
//  ItemComponentTests.swift
//  Ah Leongs FarmTests
//
//  Created by Lester Ong on 21/3/25.
//

import XCTest
@testable import Ah_Leongs_Farm

final class ItemComponentTests: XCTestCase {
    func testInit_returnsItemComponent() {
        let itemComponent = ItemComponent()

        XCTAssertNotNil(itemComponent)
    }

}
