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
        let itemComponent = ItemComponent(itemType: .premiumFertiliser)

        XCTAssertNotNil(itemComponent)
        XCTAssertEqual(itemComponent.quantity, 1)
        XCTAssertFalse(itemComponent.stackable)
    }

    func testInit_stackable_returnsItemComponent() {
        let itemComponent = ItemComponent(itemType: .bokChoySeed)

        XCTAssertNotNil(itemComponent)
        XCTAssertEqual(itemComponent.quantity, 1)
        XCTAssertTrue(itemComponent.stackable)
    }

    func testAdd_stackableValidAmount_increasesQuantity() {
        let itemComponent = ItemComponent(itemType: .bokChoySeed)
        itemComponent.add(10)

        XCTAssertEqual(itemComponent.quantity, 11)
    }

    func testAdd_stackableInvalidAmount_doesNothing() {
        let itemComponent = ItemComponent(itemType: .bokChoySeed)
        itemComponent.add(-5)

        XCTAssertEqual(itemComponent.quantity, 1)
    }

    func testAdd_stackableZeroAmount_doesNothing() {
        let itemComponent = ItemComponent(itemType: .bokChoySeed)
        itemComponent.add(0)

        XCTAssertEqual(itemComponent.quantity, 1)
    }

    func testAdd_nonStackableValidAmount_doesNothing() {
        let itemComponent = ItemComponent(itemType: .premiumFertiliser)
        itemComponent.add(10)

        XCTAssertEqual(itemComponent.quantity, 1)
    }

    func testRemove_nonStackableExcessAmount_doesNothing() {
        let itemComponent = ItemComponent(itemType: .premiumFertiliser)
        itemComponent.remove(10)

        XCTAssertEqual(itemComponent.quantity, 1)
    }

    func testRemove_nonStackableValidAmount_doesNothing() {
        let itemComponent = ItemComponent(itemType: .premiumFertiliser)
        itemComponent.remove(1)

        XCTAssertEqual(itemComponent.quantity, 0)
    }

    func testRemove_stackableNegativeAmount_doesNothing() {
        let itemComponent = ItemComponent(itemType: .bokChoySeed)
        itemComponent.remove(-10)

        XCTAssertEqual(itemComponent.quantity, 1)
    }

    func testRemove_stackableValidAmount_doesNothing() {
        let itemComponent = ItemComponent(itemType: .bokChoySeed)
        itemComponent.remove(1)

        XCTAssertEqual(itemComponent.quantity, 0)
    }

    func testHasSufficientQuantity_hasSufficient_returnsTrue() {
        let itemComponent = ItemComponent(itemType: .bokChoySeed)

        XCTAssertTrue(itemComponent.hasSufficientQuantity(1))
    }

    func testHasSufficientQuantity_hasInsufficient_returnsFalse() {
        let itemComponent = ItemComponent(itemType: .premiumFertiliser)

        XCTAssertFalse(itemComponent.hasSufficientQuantity(10))
    }
}
