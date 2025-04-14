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
    func buyItem(type: EntityType, quantity: Int) -> [Entity]? {
        // Check if the item exists in the buy market and if there's enough stock
        guard let currentStock = itemStocks[type], currentStock >= quantity else {
            print("Not enough stock for \(type).")
            return nil
        }

        var purchasedEntities: [Entity] = []

        for _ in 0..<quantity {
            let entity = EntityFactoryRegistry.createItem(type: type)

            addEntityToSellMarket(entity: entity)

            purchasedEntities.append(entity)
            manager?.addEntity(entity)
        }

        itemStocks[type] = currentStock - quantity

        return purchasedEntities
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
    
    func addEntityToSellMarket(entity: Entity) {
        if sellableEntityTypes.contains(entity.type) {
            entity.attachComponent(SellComponent())
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
