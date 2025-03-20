//
//  RewardGrantEvent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/3/25.
//

class RewardGrantEvent: GameEvent {
    private let reward: Reward

    init(reward: Reward) {
        self.reward = reward
    }

    func execute(in context: EventContext) -> EventData? {
        var eventData = EventData(eventType: .rewardGrant)
        if let currencyReward = reward.currencyReward {
            grantCurrencyReward(type: currencyReward.type,
                                amount: currencyReward.amount,
                                in: context,
                                eventData: &eventData)
        }

        if let itemReward = reward.itemReward {
            grantItemReward(type: itemReward.type,
                            stackable: itemReward.stackable,
                            quantity: itemReward.quantity,
                            in: context,
                            eventData: &eventData)
        }

        if let xpReward = reward.xpReward {
            grantXPReward(amount: xpReward,
                          in: context,
                          eventData: &eventData)
        }
        return eventData
    }

    private func grantXPReward(amount: Float, in context: EventContext, eventData: inout EventData) {
        if let levelSystem = context.getSystem(ofType: LevelSystem.self) {
            levelSystem.addXP(Float(amount))
            eventData.addData(type: .xpGrantAmount, value: amount)
        }
    }

    private func grantCurrencyReward(type: CurrencyType,
                                     amount: Double,
                                     in context: EventContext,
                                     eventData: inout EventData) {
        if let walletSystem = context.getSystem(ofType: WalletSystem.self) {
            walletSystem.addCurrencyToAll(type, amount: Double(amount))
            eventData.addData(type: .currencyGrant, value: type)
        }
    }

    private func grantItemReward(type: ItemType,
                                 stackable: Bool,
                                 quantity: Int,
                                 in context: EventContext,
                                 eventData: inout EventData) {
        if let inventorySystem = context.getSystem(ofType: InventorySystem.self) {
            let newItem = inventorySystem.createItem(type: type,
                                                     quantity: quantity,
                                                     stackable: stackable)
            inventorySystem.addItem(newItem)
        }
    }
}
