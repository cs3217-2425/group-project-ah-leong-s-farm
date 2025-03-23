//
//  InventoryComponentTests.swift
//  Ah Leongs FarmTests
//
//  Created by Lester Ong on 21/3/25.
//

import XCTest
import GameplayKit
@testable import Ah_Leongs_Farm

final class InventoryComponentTests: XCTestCase {
    func testInit_noArgs_createsInventoryComponentWithNoItems() {
        let inventoryComponent = InventoryComponent()

        XCTAssertNotNil(inventoryComponent)
        XCTAssert(inventoryComponent.items.isEmpty)
    }

    func testInit_withEntities_createsInventoryComponentWithItems() {
        let entity1 = GKEntity()
        let entity2 = GKEntity()
        let inventoryComponent = InventoryComponent(items: [entity1, entity2])

        XCTAssertNotNil(inventoryComponent)
        XCTAssertEqual(inventoryComponent.items.count, 2)
    }
}

        

