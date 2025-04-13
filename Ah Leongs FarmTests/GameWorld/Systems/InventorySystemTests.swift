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
    // TODO: REWRITE TESTS
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

    func testAddItem_createsCorrectQuantity() {
        inventorySystem.addItem(type: .bokChoySeed, quantity: 2)
        XCTAssertEqual(inventorySystem.getNumberOfItems(of: .bokChoySeed), 2)
    }

    func testRemoveItem_removesCorrectItem() {
        inventorySystem.addItem(type: .bokChoySeed, quantity: 1)
        guard let item = inventorySystem.getAllComponents().first else {
            XCTFail("Failed to retrieve item")
            return
        }
        inventorySystem.removeItem(item)
        XCTAssertFalse(inventorySystem.hasItem(item))
    }

    func testHasItem_returnsCorrectValue() {
        inventorySystem.addItem(type: .premiumFertiliser, quantity: 1)
        XCTAssertTrue(inventorySystem.hasItem(of: .premiumFertiliser))
        XCTAssertFalse(inventorySystem.hasItem(of: .bokChoySeed))
    }

    func testHasItem_existingItem_returnsTrue() {
        inventorySystem.addItem(type: .premiumFertiliser, quantity: 1)
        XCTAssertTrue(inventorySystem.hasItem(of: .premiumFertiliser))
    }

    func testHasItem_nonExistingItem_returnsFalse() {
        inventorySystem.addItem(type: .bokChoySeed, quantity: 1)
        XCTAssertFalse(inventorySystem.hasItem(of: .premiumFertiliser))
    }

    func testGetAllComponents_noComponents_returnsEmptyArray() {
        let allComponents = inventorySystem.getAllComponents()

        XCTAssertEqual(allComponents, [])
    }

    func testGetItemsByQuantity_returnsCorrectMapping() {
        inventorySystem.addItem(type: .bokChoySeed, quantity: 2)
        inventorySystem.addItem(type: .premiumFertiliser, quantity: 1)

        let itemsByQuantity = inventorySystem.getItemsByQuantity()
        XCTAssertEqual(itemsByQuantity[.bokChoySeed], 2)
        XCTAssertEqual(itemsByQuantity[.premiumFertiliser], 1)
    }

    func testGetNumberOfItems_noItems_returnsZero() {
        let numOfItems = inventorySystem.getNumberOfItems(of: .bokChoySeed)

        XCTAssertEqual(numOfItems, 0)
    }
}
