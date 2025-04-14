//
//  MarketSystem.swift
//  Ah Leongs Farm
//
//  Created by proglab on 29/3/25.
//

class MarketSystem: ISystem {

    private var itemPrices: [EntityType: Price] = MarketInformation.initialItemPrices
    private var itemStocks: [EntityType: Int] = MarketInformation.initialItemStocks
    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func getItemPrices() -> [EntityType: Price] {
        itemPrices
    }

    func getItemStocks() -> [EntityType: Int] {
        itemStocks
    }

    func getSellQuantity(for itemType: EntityType) -> Int {
        getSellableEntitiesOf(itemType).count
    }

    func getBuyPrice(for type: EntityType, currency: CurrencyType) -> Double? {
        guard let price = itemPrices[type] else {
            print("Item not found in the market!")
            return nil
        }
        return price.buyPrice[currency]
    }

    func getSellPrice(for type: EntityType, currency: CurrencyType) -> Double? {
        guard let price = itemPrices[type] else {
            print("Item not found in the market!")
            return nil
        }
        return price.sellPrice[currency]
    }

    func getBuyQuantity(for type: EntityType) -> Int? {
        guard let stock = itemStocks[type] else {
            print("Item not found in the market!")
            return nil
        }
        return stock
    }

    @discardableResult
    func buyItem(type: EntityType, quantity: Int) -> Bool {
        // Check if the item exists in the market and if there's enough stock
        guard let currentStock = itemStocks[type], currentStock >= quantity else {
            print("Not enough stock for \(type).")
            return false
        }

        for _ in 0..<quantity {
            manager?.addEntity(ItemFactory.createItem(type: type))
        }
        itemStocks[type] = currentStock - quantity

        return true
    }

    @discardableResult
    func sellItem(type: EntityType, quantity: Int) -> Bool {
        guard let manager = manager else {
            return false
        }

        let sellableEntities = getSellableEntitiesOf(type)

        if sellableEntities.count < quantity {
            print("Not enough stock for \(type).")
            return false
        }

        let entitiesToSell = sellableEntities.prefix(quantity)
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

    private func getSellableEntitiesOf(_ type: EntityType) -> [Entity] {
        guard let manager = manager else {
            return []
        }
        return manager.getEntities(withComponentType: SellComponent.self)
            .filter({
                $0.type == type
            })
    }
}
