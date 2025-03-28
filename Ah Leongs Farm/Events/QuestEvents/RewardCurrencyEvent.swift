//
//  RewardCurrencyEvent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 29/3/25.
//

class RewardCurrencyEvent: GameEvent {
    private let currencies: [CurrencyType: Double]

    init(currencies: [CurrencyType: Double]) {
        self.currencies = currencies
    }

    func execute(in context: EventContext, queueable: EventQueueable) -> EventData? {
        var eventData = CurrencyGrantEventData()
        guard let walletSystem = context.getSystem(ofType: WalletSystem.self) else {
            return nil
        }

        for (type, amount) in currencies {
            walletSystem.addCurrencyToAll(type, amount: amount)
            eventData.currencyGrants[type] = amount
        }
        return eventData
    }
}
