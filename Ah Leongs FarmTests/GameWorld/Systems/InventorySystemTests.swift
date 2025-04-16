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
        let testItem = createTestEntity()

        manager.addEntity(testItem)

        XCTAssertEqual(inventorySystem.getAllComponents().count, 1)
    }

    func testAddItem_withoutItemComponent_doesNotAddToInventory() {
        let entityWithoutItemComponent = EntityAdapter()

        manager.addEntity(entityWithoutItemComponent)

        XCTAssertEqual(inventorySystem.getAllComponents().count, 0)
    }

    func testAddItems_addsMultipleItemsToInventory() {
        let testItems = [createTestEntity(), createTestEntity(), createTestEntity()]

        manager.addEntities(testItems)

        XCTAssertEqual(inventorySystem.getAllComponents().count, 3)
    }

    func testRemoveItem_removesItemFromInventory() {
        let testItem = createTestEntity()
        manager.addEntity(testItem)

        manager.removeComponent(ofType: ItemComponent.self, from: testItem)

        XCTAssertEqual(inventorySystem.getAllComponents().count, 0)
    }

    func testHasItem_withExistingItem_returnsTrue() {
        let testItem = createTestEntity()
        manager.addEntity(testItem)

        guard let itemComponent = testItem.getComponentByType(ofType: ItemComponent.self) else {
            XCTFail("Failed to get ItemComponent")
            return
        }

        XCTAssertTrue(inventorySystem.hasItem(itemComponent))
    }

    func testHasItem_withNonExistingItem_returnsFalse() {
        let testItem = createTestEntity()

        guard let itemComponent = testItem.getComponentByType(ofType: ItemComponent.self) else {
            XCTFail("Failed to get ItemComponent")
            return
        }

        XCTAssertFalse(inventorySystem.hasItem(itemComponent))
    }

    func testHasItemOfType_withExistingType_returnsTrue() {
        let testItem = TestItemEntity()
        testItem.attachComponent(ItemComponent())
        manager.addEntity(testItem)

        XCTAssertTrue(inventorySystem.hasItem(of: TestItemEntity.type))
    }

    func testHasItemOfType_withNonExistingType_returnsFalse() {
        let testItem = TestItemEntity()
        testItem.attachComponent(ItemComponent())
        manager.addEntity(testItem)

        XCTAssertFalse(inventorySystem.hasItem(of: DifferentTestItemEntity.type))
    }

    func testGetAllComponents_returnsAllItemComponents() {
        let item1 = createTestEntity()
        let item2 = createTestEntity()

        manager.addEntity(item1)
        manager.addEntity(item2)

        let allComponents = inventorySystem.getAllComponents()

        XCTAssertEqual(allComponents.count, 2)
    }

    // MARK: - Helper Methods

    private func createTestEntity() -> Entity {
        let entity = TestItemEntity()
        entity.attachComponent(ItemComponent())
        return entity
    }
}

// MARK: - Test Entity Classes

private class TestItemEntity: EntityAdapter {}
private class DifferentTestItemEntity: EntityAdapter {}
