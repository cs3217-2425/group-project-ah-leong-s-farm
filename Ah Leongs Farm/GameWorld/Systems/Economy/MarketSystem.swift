//
//  MarketSystem.swift
//  Ah Leongs Farm
//
//  Created by proglab on 29/3/25.
//

import GameplayKit

class MarketSystem: ISystem {

    private var itemPrices: [ItemType: Price] = MarketInformation.initialItemPrices
    private var itemStocks: [ItemType: Int] = MarketInformation.initialItemStocks
    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func getItemPrices() -> [ItemType: Price] {
        itemPrices
    }

    func getItemStocks() -> [ItemType: Int] {
        itemStocks
    }

    private var sellableItems: [GKEntity] {
        manager?.getEntities(withComponentType: SellComponent.self) ?? []
    }

    func getBuyPrice(for type: ItemType, currency: CurrencyType) -> Double? {
        guard let price = itemPrices[type] else {
            print("Item not found in the market!")
            return nil
        }
        return price.buyPrice[currency]
    }

    func getSellPrice(for type: ItemType, currency: CurrencyType) -> Double? {
        guard let price = itemPrices[type] else {
            print("Item not found in the market!")
            return nil
        }
        return price.sellPrice[currency]
    }

    func getStock(for type: ItemType) -> Int? {
        guard let stock = itemStocks[type] else {
            print("Item not found in the market!")
            return nil
        }
        return stock
    }

    @discardableResult
    func buyItem(type: ItemType, quantity: Int) -> Bool {
        // Check if the item exists in the market and if there's enough stock
        guard let currentStock = itemStocks[type], currentStock >= quantity else {
            print("Not enough stock for \(type).")
            return false
        }

        guard let factoryEntity = ItemFactory.itemToInitialisers[type], let entity = factoryEntity else {
            print("Item not found in the item factory.")
            return false
        }

        itemStocks[type] = currentStock - quantity
        manager?.addEntity(entity)

        return true
    }

    @discardableResult
    func sellItem(type: ItemType, quantity: Int) -> Bool {
        guard let manager = manager else {
            return false
        }

        let entities = sellableItems.filter { entity in
            if let itemComponent = entity.component(ofType: ItemComponent.self) {
                return itemComponent.itemType == type
            }
            return false
        }

        if entities.count < quantity {
            print("Not enough stock for \(type).")
            return false
        }

        let entitiesToSell = entities.prefix(quantity)
        for entity in entitiesToSell {
            manager.removeEntity(entity)
        }

        return true
    }

    func resetItemStocks() {
        itemStocks = MarketInformation.initialItemStocks
    }

    func updateBuyandSellPrice() {
        // To be added once buy and sell price algo is decided
    }
}
