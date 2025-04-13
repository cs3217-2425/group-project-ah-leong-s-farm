//
//  MarketSystemTests.swift
//  Ah Leongs Farm
//
//  Created by proglab on 6/4/25.
//

import XCTest
@testable import Ah_Leongs_Farm

class MarketSystemTests: XCTestCase {
    var marketSystem: MarketSystem!
    var manager: EntityManager!

    override func setUp() {
        super.setUp()
        manager = EntityManager()
        marketSystem = MarketSystem(for: manager)
    }

    override func tearDown() {
        marketSystem = nil
        manager = nil
        super.tearDown()
    }

    func testGetItemPrices() {
        let itemPrices = marketSystem.getItemPrices()

        XCTAssertEqual(itemPrices[.bokChoySeed]?.buyPrice[.coin], 5.0)
        XCTAssertEqual(itemPrices[.bokChoySeed]?.sellPrice[.coin], 3.0)
        XCTAssertEqual(itemPrices[.appleSeed]?.buyPrice[.coin], 10.0)
        XCTAssertEqual(itemPrices[.appleSeed]?.sellPrice[.coin], 6.0)
    }

    func testGetItemStocks() {
        let itemStocks = marketSystem.getItemStocks()

        XCTAssertEqual(itemStocks[.bokChoySeed], Int.max)
        XCTAssertEqual(itemStocks[.appleSeed], Int.max)
        XCTAssertEqual(itemStocks[.potatoHarvested], Int.max)
    }

    func testGetBuyPrice() {
        let buyPrice = marketSystem.getBuyPrice(for: .bokChoySeed, currency: .coin)
        XCTAssertEqual(buyPrice, 5.0)

        let nonExistentItemPrice = marketSystem.getBuyPrice(for: .bokChoySeed, currency: .coin)
        XCTAssertNotNil(nonExistentItemPrice)
    }

    func testGetSellPrice() {
        let sellPrice = marketSystem.getSellPrice(for: .bokChoySeed, currency: .coin)
        XCTAssertEqual(sellPrice, 3.0)

        let sellCoinPrice = marketSystem.getSellPrice(for: .bokChoySeed, currency: .coin)
        XCTAssertNotNil(sellCoinPrice)
    }

    func testGetBuyQuantity() {
        let buyQuantity = marketSystem.getBuyQuantity(for: .bokChoySeed)
        XCTAssertEqual(buyQuantity, Int.max)
    }

    func testGetSellQuantity_noEntities_returnsZero() {
        let sellQuantity = marketSystem.getSellQuantity(for: .bokChoySeed)
        XCTAssertEqual(sellQuantity, 0)
    }

    func testGetSellQuantity_withEntities() {
        let seedEntity1 = BokChoy.createSeed()
        seedEntity1.attachComponent(SellComponent())
        manager.addEntity(seedEntity1)

        let seedEntity2 = BokChoy.createSeed()
        seedEntity2.attachComponent(SellComponent())
        manager.addEntity(seedEntity2)

        let seedEntity3 = BokChoy.createSeed()
        manager.addEntity(seedEntity3)

        let sellQuantity = marketSystem.getSellQuantity(for: .bokChoySeed)
        XCTAssertEqual(sellQuantity, 2)
    }

    func testBuyItem_validItem_success() {
        let initialEntitiesCount = manager.getAllEntities().count

        let result = marketSystem.buyItem(type: .bokChoySeed, quantity: 3)

        XCTAssertTrue(result)
        XCTAssertEqual(manager.getAllEntities().count, initialEntitiesCount + 3)
    }

    func testSellItem_sufficientQuantity_success() {
        let seedEntity1 = BokChoy.createSeed()
        seedEntity1.attachComponent(SellComponent())
        manager.addEntity(seedEntity1)

        let seedEntity2 = BokChoy.createSeed()
        seedEntity2.attachComponent(SellComponent())
        manager.addEntity(seedEntity2)

        let initialEntitiesCount = manager.getAllEntities().count

        let result = marketSystem.sellItem(type: .bokChoySeed, quantity: 1)

        XCTAssertTrue(result)
        XCTAssertEqual(manager.getAllEntities().count, initialEntitiesCount - 1)
    }

    func testSellItem_insufficientQuantity_failure() {
        let seedEntity = BokChoy.createSeed()
        seedEntity.attachComponent(SellComponent())
        manager.addEntity(seedEntity)

        let initialEntitiesCount = manager.getAllEntities().count

        let result = marketSystem.sellItem(type: .bokChoySeed, quantity: 2)

        XCTAssertFalse(result)
        XCTAssertEqual(manager.getAllEntities().count, initialEntitiesCount)
    }

    func testSellItem_noEntities_failure() {
        let result = marketSystem.sellItem(type: .bokChoySeed, quantity: 1)

        XCTAssertFalse(result)
    }

    func testResetItemStocks() {
        marketSystem.resetItemStocks()

        let resetStocks = marketSystem.getItemStocks()
        XCTAssertEqual(resetStocks[.bokChoySeed], Int.max)
        XCTAssertEqual(resetStocks[.appleSeed], Int.max)
    }
}
