//
//  BuyEvent.swift
//  Ah Leongs Farm
//
//  Created by proglab on 29/3/25.
//

class SellItemEvent: GameEvent {
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
              let price = marketSystem.getSellPrice(for: itemType, currency: currencyType)
        else {
            return nil
        }

        let totalProfit = price * Double(quantity)

        if marketSystem.sellItem(type: itemType, quantity: quantity) {
            walletSystem.addCurrencyToAll(currencyType, amount: totalProfit)
        } else {
            print("Failed to sell \(quantity) of \(itemType).")
        }

        return SellItemEventData(itemType: itemType, quantity: quantity)
    }
}
