//
//  InventoryTests.swift
//  Ah Leongs FarmTests
//
//  Created by Lester Ong on 21/3/25.
//

import XCTest
@testable import Ah_Leongs_Farm

final class InventoryTests: XCTestCase {
    func testInit_createsInventoryWithComponent() {
        let inventory = Inventory()

        XCTAssertNotNil(inventory)
        XCTAssertEqual(inventory.components.count, 1)
        XCTAssertNotNil(inventory.component(ofType: InventoryComponent.self))
    }
}
