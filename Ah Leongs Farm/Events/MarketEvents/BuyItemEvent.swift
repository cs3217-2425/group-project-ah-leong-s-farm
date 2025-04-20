//
//  BuyEvent.swift
//  Ah Leongs Farm
//
//  Created by proglab on 29/3/25.
//

class BuyItemEvent: GameEvent {
    private let itemType: EntityType
    private let quantity: Int
    private let currencyType: CurrencyType

    init(itemType: EntityType, quantity: Int, currencyType: CurrencyType) {
        self.itemType = itemType
        self.quantity = quantity
        self.currencyType = currencyType
    }

    func execute(in context: EventContext, queueable: EventQueueable) -> EventData? {

        guard let marketSystem = context.getSystem(ofType: MarketSystem.self),
                  let walletSystem = context.getSystem(ofType: WalletSystem.self),
                  let inventorySystem = context.getSystem(ofType: InventorySystem.self),
                  let soundSystem = context.getSystem(ofType: SoundSystem.self),
                  let price = marketSystem.getBuyPrice(for: itemType, currency: currencyType),
                  let stock = marketSystem.getBuyQuantity(for: itemType), stock >= quantity
        else {
            return nil
        }

        let totalCost = price * Double(quantity)
        let totalCurrency = walletSystem.getTotalAmount(of: currencyType)

        if totalCurrency < totalCost {
            return nil
        }

        let purchasedItems = EntityFactoryRegistry.createMultiple(type: itemType,
                                                                  quantity: quantity)
        context.addEntities(purchasedItems)
        marketSystem.decreaseStock(type: itemType, quantity: quantity)
        marketSystem.addEntitiesToSellMarket(entities: purchasedItems)
        soundSystem.playSoundEffect(named: "money")

        inventorySystem.addItemsToInventory(purchasedItems)
        walletSystem.removeCurrencyFromAll(currencyType, amount: totalCost)

        return BuyItemEventData(itemType: itemType, quantity: quantity)
    }
}
