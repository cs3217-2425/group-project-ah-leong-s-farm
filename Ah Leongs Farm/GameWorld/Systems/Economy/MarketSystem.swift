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

    private var recentBuyVolumes: [EntityType: Int] = [:]
    private var recentSellVolumes: [EntityType: Int] = [:]
    private var netVolumeWindow: [EntityType: [Int]] = [:]
    private let windowSize = 1

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
        recentBuyVolumes[type, default: 0] += quantity
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
        recentSellVolumes[type, default: 0] += quantity
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

    func updateMarketPrices() {
        for (type, basePrice) in MarketInformation.initialItemPrices {
            let avgNet = updateAndGetAverageNet(for: type)
            let newPrice = calculateSmoothedPrice(for: type, basePrice: basePrice, avgNet: avgNet)
            itemPrices[type] = newPrice
        }

        recentBuyVolumes.removeAll()
        recentSellVolumes.removeAll()
    }

    private func updateAndGetAverageNet(for type: EntityType) -> Double {
        let net = (recentBuyVolumes[type] ?? 0) - (recentSellVolumes[type] ?? 0)

        var window = netVolumeWindow[type] ?? []
        window.append(net)
        if window.count > windowSize {
            window.removeFirst()
        }
        netVolumeWindow[type] = window

        return Double(window.reduce(0, +)) / Double(max(1, window.count))
    }

    private func calculateSmoothedPrice(for type: EntityType, basePrice: Price, avgNet: Double) -> Price {
        let α = 0.05
        let decay = 0.90

        var newBuyPrice: [CurrencyType: Double] = [:]
        var newSellPrice: [CurrencyType: Double] = [:]

        for currency in basePrice.buyPrice.keys {
            let baseBuy  = basePrice.buyPrice[currency] ?? 0
            let baseSell = basePrice.sellPrice[currency] ?? 0

            let targetBuy  = baseBuy * (1 + α * avgNet)
            let targetSell = baseSell * (1 + α * avgNet)

            let prevBuy  = itemPrices[type]?.buyPrice[currency] ?? baseBuy
            let prevSell = itemPrices[type]?.sellPrice[currency] ?? baseSell

            let newBuy  = prevBuy * (1 - decay) + targetBuy  * decay
            let newSell = prevSell * (1 - decay) + targetSell * decay

            newBuyPrice[currency] = Double(max(1, Int(newBuy.rounded())))
            newSellPrice[currency] = Double(max(1, Int(newSell.rounded())))
        }

        return Price(buyPrice: newBuyPrice, sellPrice: newSellPrice)
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
