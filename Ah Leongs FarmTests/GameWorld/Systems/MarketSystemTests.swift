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
    let MAX_QUANTITY = 999

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

        XCTAssertEqual(itemPrices[BokChoySeed.type]?.buyPrice[.coin], 5.0)
        XCTAssertEqual(itemPrices[BokChoySeed.type]?.sellPrice[.coin], 3.0)
        XCTAssertEqual(itemPrices[AppleSeed.type]?.buyPrice[.coin], 10.0)
        XCTAssertEqual(itemPrices[AppleSeed.type]?.sellPrice[.coin], 6.0)
    }

    func testGetItemStocks() {
        let itemStocks = marketSystem.getItemStocks()

        XCTAssertEqual(itemStocks[BokChoySeed.type], MAX_QUANTITY)
        XCTAssertEqual(itemStocks[AppleSeed.type], MAX_QUANTITY)
        XCTAssertEqual(itemStocks[Potato.type], MAX_QUANTITY)
    }

    func testGetBuyPrice() {
        let buyPrice = marketSystem.getBuyPrice(for: BokChoySeed.type, currency: .coin)
        XCTAssertEqual(buyPrice, 5.0)

        let nonExistentItemPrice = marketSystem.getBuyPrice(for: BokChoySeed.type, currency: .coin)
        XCTAssertNotNil(nonExistentItemPrice)
    }

    func testGetSellPrice() {
        let sellPrice = marketSystem.getSellPrice(for: BokChoySeed.type, currency: .coin)
        XCTAssertEqual(sellPrice, 3.0)

        let sellCoinPrice = marketSystem.getSellPrice(for: BokChoySeed.type, currency: .coin)
        XCTAssertNotNil(sellCoinPrice)
    }

    func testGetBuyQuantity() {
        let buyQuantity = marketSystem.getBuyQuantity(for: BokChoySeed.type)
        XCTAssertEqual(buyQuantity, MAX_QUANTITY)
    }

    func testGetSellQuantity_noEntities_returnsZero() {
        let sellQuantity = marketSystem.getSellQuantity(for: BokChoySeed.type)
        XCTAssertEqual(sellQuantity, 0)
    }

    func testGetSellQuantity_withEntities() {
        // Create and add bokchoy seeds with sell component
        let bokChoySeed1 = BokChoySeed()
        bokChoySeed1.attachComponent(SellComponent())
        bokChoySeed1.attachComponent(ItemComponent())
        manager.addEntity(bokChoySeed1)

        let bokChoySeed2 = BokChoySeed()
        bokChoySeed2.attachComponent(SellComponent())
        bokChoySeed2.attachComponent(ItemComponent())
        manager.addEntity(bokChoySeed2)

        // Add one without sell component
        let bokChoySeed3 = BokChoySeed()
        bokChoySeed3.attachComponent(ItemComponent())
        manager.addEntity(bokChoySeed3)

        let sellQuantity = marketSystem.getSellQuantity(for: BokChoySeed.type)
        XCTAssertEqual(sellQuantity, 2)
    }

    func testDecreaseStock() {
        // Check initial stock
        XCTAssertEqual(marketSystem.getBuyQuantity(for: BokChoySeed.type), MAX_QUANTITY)

        // Decrease stock
        let result = marketSystem.decreaseStock(type: BokChoySeed.type, quantity: 5)
        XCTAssertTrue(result)

        // Check updated stock (Int.max - 5)
        XCTAssertEqual(marketSystem.getBuyQuantity(for: BokChoySeed.type), MAX_QUANTITY - 5)
    }

    func testIncreaseStock() {
        // First decrease stock to create a non-max value
        marketSystem.decreaseStock(type: BokChoySeed.type, quantity: 10)
        let initialStock = marketSystem.getBuyQuantity(for: BokChoySeed.type) ?? 0

        // Increase stock
        marketSystem.increaseStock(type: BokChoySeed.type, quantity: 5)

        // Check updated stock
        XCTAssertEqual(marketSystem.getBuyQuantity(for: BokChoySeed.type), initialStock + 5)
    }

    func testResetItemStocks() {
        // First decrease some stocks
        marketSystem.decreaseStock(type: BokChoySeed.type, quantity: 10)
        marketSystem.decreaseStock(type: AppleSeed.type, quantity: 20)

        // Reset stocks
        marketSystem.resetItemStocks()

        // Check that stocks are reset
        let resetStocks = marketSystem.getItemStocks()
        XCTAssertEqual(resetStocks[BokChoySeed.type], MAX_QUANTITY)
        XCTAssertEqual(resetStocks[AppleSeed.type], MAX_QUANTITY)
    }
}
