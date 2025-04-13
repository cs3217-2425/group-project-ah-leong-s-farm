//
//  InventorySystemTests.swift
//  Ah Leongs FarmTests
//
//  Created by Lester Ong on 21/3/25.
//

import XCTest
import GameplayKit
@testable import Ah_Leongs_Farm

final class InventorySystemTests: XCTestCase {
    var inventorySystem: InventorySystem!
    var manager: EntityManager!

    override func setUpWithError() throws {
        manager = EntityManager()
        inventorySystem = InventorySystem(for: manager)
    }

    override func tearDownWithError() throws {
        inventorySystem = nil
        manager = nil
    }

    func testInit_createsInventorySystem() {
        let inventorySystem = InventorySystem(for: manager)
        XCTAssertNotNil(inventorySystem)
    }

    func testAddItem_addsItemToInventory() {
        // Create a test entity with ItemComponent
        let testItem = createTestEntity()

        // Add the item to inventory
        inventorySystem.addItem(testItem)

        // Verify the item was added
        XCTAssertEqual(inventorySystem.getAllComponents().count, 1)
    }

    func testAddItem_withoutItemComponent_doesNotAddToInventory() {
        // Create an entity without ItemComponent
        let entityWithoutItemComponent = EntityAdapter()

        // Try to add it to inventory
        inventorySystem.addItem(entityWithoutItemComponent)

        // Verify the item was not added
        XCTAssertEqual(inventorySystem.getAllComponents().count, 0)
    }

    func testAddItems_addsMultipleItemsToInventory() {
        // Create multiple test entities
        let testItems = [createTestEntity(), createTestEntity(), createTestEntity()]

        // Add the items to inventory
        inventorySystem.addItems(testItems)

        // Verify all items were added
        XCTAssertEqual(inventorySystem.getAllComponents().count, 3)
    }

    func testRemoveItem_removesItemFromInventory() {
        // Create and add a test entity
        let testItem = createTestEntity()
        inventorySystem.addItem(testItem)

        // Get the item component
        guard let itemComponent = testItem.getComponentByType(ofType: ItemComponent.self) else {
            XCTFail("Failed to get ItemComponent")
            return
        }

        // Remove the item
        inventorySystem.removeItem(itemComponent)

        // Verify the item was removed
        XCTAssertEqual(inventorySystem.getAllComponents().count, 0)
    }

    func testHasItem_withExistingItem_returnsTrue() {
        // Create and add a test entity
        let testItem = createTestEntity()
        inventorySystem.addItem(testItem)

        // Get the item component
        guard let itemComponent = testItem.getComponentByType(ofType: ItemComponent.self) else {
            XCTFail("Failed to get ItemComponent")
            return
        }

        // Check if the inventory has the item
        XCTAssertTrue(inventorySystem.hasItem(itemComponent))
    }

    func testHasItem_withNonExistingItem_returnsFalse() {
        // Create but don't add a test entity
        let testItem = createTestEntity()

        // Get the item component
        guard let itemComponent = testItem.getComponentByType(ofType: ItemComponent.self) else {
            XCTFail("Failed to get ItemComponent")
            return
        }

        // Check if the inventory has the item (should be false)
        XCTAssertFalse(inventorySystem.hasItem(itemComponent))
    }

    func testHasItemOfType_withExistingType_returnsTrue() {
        // Create and add a TestItemEntity
        let testItem = TestItemEntity()
        testItem.attachComponent(ItemComponent())
        inventorySystem.addItem(testItem)

        // Check if the inventory has an item of that type
        XCTAssertTrue(inventorySystem.hasItem(of: TestItemEntity.self))
    }

    func testHasItemOfType_withNonExistingType_returnsFalse() {
        // Create and add a TestItemEntity
        let testItem = TestItemEntity()
        testItem.attachComponent(ItemComponent())
        inventorySystem.addItem(testItem)

        // Check if the inventory has an item of a different type (should be false)
        XCTAssertFalse(inventorySystem.hasItem(of: DifferentTestItemEntity.self))
    }

    func testGetAllComponents_returnsAllItemComponents() {
        // Create and add multiple entities with different quantities
        let item1 = createTestEntity(quantity: 5)
        let item2 = createTestEntity(quantity: 10)

        inventorySystem.addItem(item1)
        inventorySystem.addItem(item2)

        // Get all components
        let allComponents = inventorySystem.getAllComponents()

        // Verify the count and quantities
        XCTAssertEqual(allComponents.count, 2)

        let quantities = allComponents.map { $0.quantity }.sorted()
        XCTAssertEqual(quantities, [5, 10])
    }

    // MARK: - Helper Methods

    private func createTestEntity(quantity: Int = 1) -> Entity {
        let entity = TestItemEntity()
        entity.attachComponent(ItemComponent(quantity: quantity))
        return entity
    }
}

// MARK: - Test Entity Classes

private class TestItemEntity: EntityAdapter {}
private class DifferentTestItemEntity: EntityAdapter {}
