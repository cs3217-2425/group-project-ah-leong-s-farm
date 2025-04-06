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

    func testInitialItemPrices() {
        let itemPrices = marketSystem.getItemPrices()

        XCTAssertEqual(itemPrices[.bokChoySeed]?.buyPrice[.coin], 5.0)
        XCTAssertEqual(itemPrices[.bokChoySeed]?.sellPrice[.coin], 3.0)
        XCTAssertEqual(itemPrices[.appleSeed]?.buyPrice[.coin], 10.0)
    }

    func testInitialItemStocks() {
        let itemStocks = marketSystem.getItemStocks()

        XCTAssertEqual(itemStocks[.bokChoySeed], Int.max)
        XCTAssertEqual(itemStocks[.potatoHarvested], Int.max)
    }

    func testGetSellQuantity() {
        let entity1 = BokChoy()
        let sellComponent1 = SellComponent(itemType: .bokChoySeed)
        entity1.addComponent(sellComponent1)

        let entity2 = BokChoy()
        let sellComponent2 = SellComponent(itemType: .bokChoySeed)
        entity2.addComponent(sellComponent2)

        manager.addEntity(entity1)
        manager.addEntity(entity2)

        let sellQuantity = marketSystem.getSellQuantity(for: .bokChoySeed)

        XCTAssertEqual(sellQuantity, 2)
    }

    func testBuyItemSuccess() {
        let result = marketSystem.buyItem(type: .bokChoySeed, quantity: 1)

        XCTAssertTrue(result)
        XCTAssertEqual(manager.getEntities(withComponentType: ItemComponent.self).count, 1)
        XCTAssertEqual(manager.getEntities(withComponentType: SellComponent.self).count, 1)
    }

    func testSellItemSuccess() {
        let entity1 = BokChoy()
        let sellComponent1 = SellComponent(itemType: .bokChoySeed)
        entity1.addComponent(sellComponent1)

        let entity2 = BokChoy()
        let sellComponent2 = SellComponent(itemType: .bokChoySeed)
        entity2.addComponent(sellComponent2)

        let entity3 = BokChoy()
        let sellComponent3 = SellComponent(itemType: .bokChoySeed)
        entity3.addComponent(sellComponent3)

        manager.addEntity(entity1)
        manager.addEntity(entity2)
        manager.addEntity(entity3)

        XCTAssertEqual(manager.getAllEntities().count, 3)

        let result = marketSystem.sellItem(type: .bokChoySeed, quantity: 2)

        XCTAssertTrue(result)
        XCTAssertEqual(manager.getAllEntities().count, 1)
    }

    func testSellItemFailure() {
        let entity = BokChoy()
        let sellComponent = SellComponent(itemType: .bokChoySeed)
        entity.addComponent(sellComponent)

        manager.addEntity(entity)

        let result = marketSystem.sellItem(type: .bokChoySeed, quantity: 2)

        XCTAssertFalse(result)
        XCTAssertEqual(manager.getAllEntities().count, 1)
    }

    func testResetItemStocks() {
        marketSystem.buyItem(type: .bokChoySeed, quantity: 5)
        marketSystem.resetItemStocks()

        let itemStocks = marketSystem.getItemStocks()
        XCTAssertEqual(itemStocks[.bokChoySeed], Int.max)
    }
}
