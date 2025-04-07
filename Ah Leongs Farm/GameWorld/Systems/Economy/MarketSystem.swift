//
//  MarketSystem.swift
//  Ah Leongs Farm
//
//  Created by proglab on 29/3/25.
//

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

    func getSellQuantity(for itemType: ItemType) -> Int {
        sellableComponents
            .filter { $0.itemType == itemType }
            .count
    }

    private var sellableComponents: [SellComponent] {
        manager?.getAllComponents(ofType: SellComponent.self) ?? []
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

    func getBuyQuantity(for type: ItemType) -> Int? {
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

        for _ in 0..<quantity {
            guard let initialiser = ItemFactory.itemToInitialisers[type],
                  let entity = initialiser() else {
                print("Item not found in the item factory.")
                return false
            }

            manager?.addEntity(entity)
        }
        itemStocks[type] = currentStock - quantity

        return true
    }

    @discardableResult
    func sellItem(type: ItemType, quantity: Int) -> Bool {
        guard let manager = manager else {
            return false
        }

        let sellableEntities = manager.getEntities(withComponentType: SellComponent.self).filter { entity in
            if let sellComponent = entity.component(ofType: SellComponent.self) {
                return sellComponent.itemType == type
            }
            return false
        }

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
}
