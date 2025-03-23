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
        let isItemAdded = inventorySystem.addItem(GKEntity())

        XCTAssertFalse(isItemAdded)
    }

    func testAddItem_entityWithNoItemComponent_returnsFalse() {
        let entity = GKEntity()
        let isItemAdded = inventorySystem.addItem(entity)

        XCTAssertFalse(isItemAdded)
        XCTAssertEqual(inventoryComponent.items.count, 0)
    }

    func testAddItem_nonStackableEntityWithItemComponent_returnsTrue() {
        let entity1 = GKEntity()
        entity1.addComponent(ItemComponent(itemType: .premiumFertiliser))

        let entity2 = GKEntity()
        entity2.addComponent(ItemComponent(itemType: .premiumFertiliser))

        let isItemAdded1 = inventorySystem.addItem(entity1)
        let isItemAdded2 = inventorySystem.addItem(entity2)

        XCTAssertTrue(isItemAdded1)
        XCTAssertTrue(isItemAdded2)
        XCTAssertEqual(inventoryComponent.items.count, 2)
    }

    func testAddItem_stackableEntityWithItemComponent_returnsTrue() {
        let entity1 = GKEntity()
        entity1.addComponent(ItemComponent(itemType: .bokChoySeed))

        let entity2 = GKEntity()
        entity2.addComponent(ItemComponent(itemType: .bokChoySeed))

        let isItemAdded1 = inventorySystem.addItem(entity1)
        let isItemAdded2 = inventorySystem.addItem(entity2)

        XCTAssertTrue(isItemAdded1)
        XCTAssertTrue(isItemAdded2)
        XCTAssertEqual(inventoryComponent.items.count, 1)
    }

    func testRemoveItem_existingEntity_removesEntity() {
        let entity = GKEntity()
        entity.addComponent(ItemComponent(itemType: .bokChoySeed))

        inventorySystem.addItem(entity)
        inventorySystem.removeItem(entity)

        XCTAssertEqual(inventoryComponent.items.count, 0)
    }

    func testRemoveItem_nonExistingEntity_removesEntity() {
        let entity1 = GKEntity()
        entity1.addComponent(ItemComponent(itemType: .bokChoySeed))

        let entity2 = GKEntity()
        entity2.addComponent(ItemComponent(itemType: .bokChoyHarvested))

        inventorySystem.addItem(entity1)
        inventorySystem.removeItem(entity2)

        XCTAssertEqual(inventoryComponent.items.count, 1)
    }

    func testRemoveItem_existingTypeRemovesAll_removesEntity() {
        let entity = GKEntity()
        entity.addComponent(ItemComponent(itemType: .bokChoySeed))

        inventorySystem.addItem(entity)
        let isRemoved = inventorySystem.removeItem(of: .bokChoySeed)

        XCTAssertTrue(isRemoved)
        XCTAssertEqual(inventoryComponent.items.count, 0)
    }

    func testRemoveItem_nonExistingType_doesNotRemoveEntity() {
        let entity = GKEntity()
        entity.addComponent(ItemComponent(itemType: .bokChoySeed))

        inventorySystem.addItem(entity)
        let isRemoved = inventorySystem.removeItem(of: .bokChoyHarvested)

        XCTAssertFalse(isRemoved)
        XCTAssertEqual(inventoryComponent.items.count, 1)
    }

    func testRemoveItem_existingTypeRemovesSome_doesNotRemoveEntity() {
        let entity1 = GKEntity()
        entity1.addComponent(ItemComponent(itemType: .bokChoySeed))

        let entity2 = GKEntity()
        entity2.addComponent(ItemComponent(itemType: .bokChoySeed))

        inventorySystem.addItem(entity1)
        inventorySystem.addItem(entity2)
        let isRemoved = inventorySystem.removeItem(of: .bokChoySeed)

        XCTAssertTrue(isRemoved)
        XCTAssertEqual(inventoryComponent.items.count, 1)
    }

    func testHasItem_existingItem_returnsTrue() {
        let entity = GKEntity()
        entity.addComponent(ItemComponent(itemType: .bokChoySeed))

        inventorySystem.addItem(entity)
        let hasItem = inventorySystem.hasItem(entity)

        XCTAssertTrue(hasItem)
    }

    func testHasItem_nonExistingItem_returnsFalse() {
        let entity = GKEntity()
        entity.addComponent(ItemComponent(itemType: .bokChoySeed))

        let hasItem = inventorySystem.hasItem(entity)

        XCTAssertFalse(hasItem)
    }

    func testGetAllEntities_noEntities_returnsEmptyArray() {
        let allEntities = inventorySystem.getAllEntities()

        XCTAssertEqual(allEntities, [])
    }

    func testGetAllEntities_hasEntities_returnsEntitiesSet() {
        let entity1 = GKEntity()
        entity1.addComponent(ItemComponent(itemType: .premiumFertiliser))

        let entity2 = GKEntity()
        entity2.addComponent(ItemComponent(itemType: .premiumFertiliser))

        inventorySystem.addItem(entity1)
        inventorySystem.addItem(entity2)
        let allEntities = inventorySystem.getAllEntities()

        XCTAssertEqual(allEntities.count, 2)
        XCTAssertTrue(allEntities.contains(entity1))
        XCTAssertTrue(allEntities.contains(entity2))
    }

    func testGetNumberOfItems_twoStackableItem_returnsCorrectNumber() {
        let entity1 = GKEntity()
        entity1.addComponent(ItemComponent(itemType: .bokChoySeed))

        let entity2 = GKEntity()
        entity2.addComponent(ItemComponent(itemType: .bokChoySeed))

        inventorySystem.addItem(entity1)
        inventorySystem.addItem(entity2)
        let numOfItems = inventorySystem.getNumberOfItems(of: .bokChoySeed)

        XCTAssertEqual(numOfItems, 2)
    }

    func testGetNumberOfItems_twoUnstackableItem_returnsCorrectNumber() {
        let entity1 = GKEntity()
        entity1.addComponent(ItemComponent(itemType: .premiumFertiliser))

        let entity2 = GKEntity()
        entity2.addComponent(ItemComponent(itemType: .premiumFertiliser))

        inventorySystem.addItem(entity1)
        inventorySystem.addItem(entity2)
        let numOfItems = inventorySystem.getNumberOfItems(of: .premiumFertiliser)

        XCTAssertEqual(numOfItems, 2)
    }

    func testGetNumberOfItems_noItems_returnsZero() {
        let numOfItems = inventorySystem.getNumberOfItems(of: .bokChoySeed)

        XCTAssertEqual(numOfItems, 0)
    }
}
