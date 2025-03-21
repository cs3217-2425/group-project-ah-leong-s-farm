//
//  InventorySystemTests.swift
//  Ah Leongs FarmTests
//
//  Created by Lester Ong on 21/3/25.
//

import XCTest
@testable import Ah_Leongs_Farm

final class InventorySystemTests: XCTestCase {
    var inventorySystem = InventorySystem()
    var inventoryComponent = InventoryComponent()

    override func setUpWithError() throws {
        inventorySystem = InventorySystem()
        inventoryComponent = InventoryComponent()
        inventorySystem.addComponent(inventoryComponent)
    }

    func testInit_createsInventorySystem() {
        let inventorySystem = InventorySystem()

        XCTAssertNotNil(inventorySystem)
    }

    func testAddItem_noInventoryComponent_returnsFalse() {
        let inventorySystem = InventorySystem()
        let isItemAdded = inventorySystem.addItem(MockGKEntity())

        XCTAssertFalse(isItemAdded)
    }

    func testAddItem_entityWithNoItemComponent_returnsFalse() {
        let entity = MockGKEntity()
        let isItemAdded = inventorySystem.addItem(entity)

        XCTAssertFalse(isItemAdded)
        XCTAssertEqual(inventoryComponent.items.count, 0)
    }

    func testAddItem_nonStackableEntityWithItemComponent_returnsTrue() {
        let entity1 = MockGKEntity()
        entity1.addComponent(ItemComponent(itemType: .bokChoySeed, stackable: false))

        let entity2 = MockGKEntity()
        entity2.addComponent(ItemComponent(itemType: .bokChoySeed, stackable: false))

        let isItemAdded1 = inventorySystem.addItem(entity1)
        let isItemAdded2 = inventorySystem.addItem(entity2)

        XCTAssertTrue(isItemAdded1)
        XCTAssertTrue(isItemAdded2)
        XCTAssertEqual(inventoryComponent.items.count, 2)
    }

    func testAddItem_stackableEntityWithItemComponent_returnsTrue() {
        let entity1 = MockGKEntity()
        entity1.addComponent(ItemComponent(itemType: .bokChoySeed, stackable: true))

        let entity2 = MockGKEntity()
        entity2.addComponent(ItemComponent(itemType: .bokChoySeed, stackable: true))

        let isItemAdded1 = inventorySystem.addItem(entity1)
        let isItemAdded2 = inventorySystem.addItem(entity2)

        XCTAssertTrue(isItemAdded1)
        XCTAssertTrue(isItemAdded2)
        XCTAssertEqual(inventoryComponent.items.count, 1)
    }
}
