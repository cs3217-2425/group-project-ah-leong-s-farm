//
//  MarketSystem.swift
//  Ah Leongs Farm
//
//  Created by proglab on 29/3/25.
//

class MarketSystem: ISystem {

    private var itemPrices: [EntityType: Price] = MarketInformation.initialItemPrices
    private var itemStocks: [EntityType: Int] = MarketInformation.initialItemStocks
    private var sellableEntityTypes: Set<EntityType> = MarketInformation.sellableItems
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
    func decreaseStock(type: EntityType, quantity: Int) -> Bool {
        // Check if the item exists in the market and if there's enough stock
        guard let currentStock = itemStocks[type], currentStock >= quantity else {
            print("Not enough stock for \(type).")
            return false
        }

        itemStocks[type] = currentStock - quantity

        return true
    }

    func increaseStock(type: EntityType, quantity: Int) {
        guard let currentStock = itemStocks[type] else {
            return
        }
        if quantity > 0 && currentStock > Int.max - quantity {
            itemStocks[type] = Int.max
        } else {
            itemStocks[type] = currentStock + quantity
        }
    }

    func addEntityToSellMarket(entity: Entity) {
        if sellableEntityTypes.contains(entity.type) {
            entity.attachComponent(SellComponent())
            manager?.addEntity(entity)
        }
    }

    func addEntitiesToSellMarket(entities: [Entity]) {
        for entity in entities {
            addEntityToSellMarket(entity: entity)
        }
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
