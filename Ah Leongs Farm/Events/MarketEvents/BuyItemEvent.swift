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
                  let price = marketSystem.getBuyPrice(for: itemType, currency: currencyType),
                  let stock = marketSystem.getBuyQuantity(for: itemType), stock >= quantity
        else {
            print("Not enough stock or systems missing.")
            return nil
        }

        let totalCost = price * Double(quantity)
        let totalCurrency = walletSystem.getTotalAmount(of: currencyType)

        if totalCurrency < totalCost {
            print("Not enough currency.")
            return nil
        }

        guard let purchasedItems = marketSystem.buyItem(type: itemType, quantity: quantity) else {
            return nil
        }

        inventorySystem.addItems(purchasedItems)
        walletSystem.removeCurrencyFromAll(currencyType, amount: totalCost)

        return BuyItemEventData(itemType: itemType, quantity: quantity)
    }
}
