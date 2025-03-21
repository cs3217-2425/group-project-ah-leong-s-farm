//
//  ItemComponentTests.swift
//  Ah Leongs FarmTests
//
//  Created by Lester Ong on 21/3/25.
//

import XCTest
@testable import Ah_Leongs_Farm

final class ItemComponentTests: XCTestCase {
    func testInit_nonStackable_returnsItemComponent() {
        let itemComponent = ItemComponent(itemType: .bokChoySeed, stackable: false)

        XCTAssertNotNil(itemComponent)
        XCTAssertEqual(itemComponent.quantity, 1)
        XCTAssertFalse(itemComponent.stackable)
    }

    func testInit_stackable_returnsItemComponent() {
        let itemComponent = ItemComponent(itemType: .bokChoySeed, stackable: true)

        XCTAssertNotNil(itemComponent)
        XCTAssertEqual(itemComponent.quantity, 1)
        XCTAssertTrue(itemComponent.stackable)
    }

    func testAdd_stackableValidAmount_increasesQuantity() {
        var itemComponent = ItemComponent(itemType: .bokChoySeed, stackable: true)
        itemComponent.add(10)

        XCTAssertEqual(itemComponent.quantity, 11)
    }

    func testAdd_stackableInvalidAmount_doesNothing() {
        var itemComponent = ItemComponent(itemType: .bokChoySeed, stackable: true)
        itemComponent.add(-5)

        XCTAssertEqual(itemComponent.quantity, 1)
    }

    func testAdd_stackableZeroAmount_doesNothing() {
        var itemComponent = ItemComponent(itemType: .bokChoySeed, stackable: true)
        itemComponent.add(0)

        XCTAssertEqual(itemComponent.quantity, 1)
    }

    func testAdd_nonStackableValidAmount_doesNothing() {
        var itemComponent = ItemComponent(itemType: .bokChoySeed, stackable: false)
        itemComponent.add(10)

        XCTAssertEqual(itemComponent.quantity, 1)
    }

    func testRemove_nonStackableExcessAmount_doesNothing() {
        var itemComponent = ItemComponent(itemType: .bokChoySeed, stackable: false)
        itemComponent.remove(10)

        XCTAssertEqual(itemComponent.quantity, 1)
    }

    func testRemove_nonStackableValidAmount_doesNothing() {
        var itemComponent = ItemComponent(itemType: .bokChoySeed, stackable: false)
        itemComponent.remove(1)

        XCTAssertEqual(itemComponent.quantity, 0)
    }

    func testRemove_stackableNegativeAmount_doesNothing() {
        var itemComponent = ItemComponent(itemType: .bokChoySeed, stackable: true)
        itemComponent.remove(-10)

        XCTAssertEqual(itemComponent.quantity, 1)
    }

    func testRemove_stackableValidAmount_doesNothing() {
        var itemComponent = ItemComponent(itemType: .bokChoySeed, stackable: true)
        itemComponent.remove(1)

        XCTAssertEqual(itemComponent.quantity, 0)
    }

    func testHasSufficientQuantity_hasSufficient_returnsTrue() {
        var itemComponent = ItemComponent(itemType: .bokChoySeed, stackable: true)

        XCTAssertTrue(itemComponent.hasSufficientQuantity(1))
    }

    func testHasSufficientQuantity_hasInsufficient_returnsFalse() {
        var itemComponent = ItemComponent(itemType: .bokChoySeed, stackable: false)

        XCTAssertFalse(itemComponent.hasSufficientQuantity(10))
    }
}
