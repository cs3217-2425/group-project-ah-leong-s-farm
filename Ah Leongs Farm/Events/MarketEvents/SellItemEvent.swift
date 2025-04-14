//
//  BuyEvent.swift
//  Ah Leongs Farm
//
//  Created by proglab on 29/3/25.
//

import Foundation
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

        let sellableEntities = context.getEntities(withComponentType: SellComponent.self)
        let filteredEntities = sellableEntities.filter {
            $0.type == itemType
        }

        guard filteredEntities.count >= quantity else {
            return nil
        }

        let entitiesToSell = filteredEntities.prefix(quantity)
        for entity in filteredEntities {
            context.removeEntity(entity)
        }

        marketSystem.increaseStock(type: itemType, quantity: quantity)

        walletSystem.addCurrencyToAll(currencyType, amount: totalProfit)

        return SellItemEventData(itemType: itemType, quantity: quantity)
    }
}
