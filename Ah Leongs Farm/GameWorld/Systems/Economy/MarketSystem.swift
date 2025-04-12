//
//  MarketSystem.swift
//  Ah Leongs Farm
//
//  Created by proglab on 29/3/25.
//

class MarketSystem: ISystem {

    private var itemPrices: [ItemTypeNew: Price] = MarketInformation.initialItemPrices
    private var itemStocks: [ItemTypeNew: Int] = MarketInformation.initialItemStocks
    private var itemTypeToEntities: [ItemTypeNew: [Entity]] {
        guard let manager = manager else {
            return [:]
        }
        return ItemTypeNew.getItemTypeToEntities(from: manager)
    }
    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func getItemPrices() -> [ItemTypeNew: Price] {
        itemPrices
    }

    func getItemStocks() -> [ItemTypeNew: Int] {
        itemStocks
    }

    func getSellQuantity(for itemType: ItemTypeNew) -> Int {
        getSellableEntitiesOf(itemType).count
    }


    func getBuyPrice(for type: ItemTypeNew, currency: CurrencyType) -> Double? {
        guard let price = itemPrices[type] else {
            print("Item not found in the market!")
            return nil
        }
        return price.buyPrice[currency]
    }

    func getSellPrice(for type: ItemTypeNew, currency: CurrencyType) -> Double? {
        guard let price = itemPrices[type] else {
            print("Item not found in the market!")
            return nil
        }
        return price.sellPrice[currency]
    }

    func getBuyQuantity(for type: ItemTypeNew) -> Int? {
        guard let stock = itemStocks[type] else {
            print("Item not found in the market!")
            return nil
        }
        return stock
    }

    @discardableResult
    func buyItem(type: ItemTypeNew, quantity: Int) -> Bool {
        // Check if the item exists in the market and if there's enough stock
        guard let currentStock = itemStocks[type], currentStock >= quantity else {
            print("Not enough stock for \(type).")
            return false
        }

        for _ in 0..<quantity {
            guard let initialiser = ItemFactory.itemToInitialisers[type] else {
                print("Item not found in the item factory.")
                return false
            }

            manager?.addEntity(initialiser())
        }
        itemStocks[type] = currentStock - quantity

        return true
    }

    @discardableResult
    func sellItem(type: ItemTypeNew, quantity: Int) -> Bool {
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

    private func getSellableEntitiesOf(_ type: ItemTypeNew) -> [Entity] {
        return itemTypeToEntities[type]?.filter {
            $0.getComponentByType(ofType: SellComponent.self) != nil
        } ?? []
    }
}
