//
//  RewardHandler.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 22/3/25.
//

protocol RewardHandler {
    func processReward(_ reward: any SpecificReward, in context: EventContext, eventData: inout EventData)
}

class XPRewardHandler: RewardHandler {
    func processReward(_ reward: any SpecificReward, in context: EventContext, eventData: inout EventData) {
        guard let xpReward = reward as? XPSpecificReward,
              let levelSystem = context.getSystem(ofType: LevelSystem.self) else {
            return
        }

        levelSystem.addXP(xpReward.amount)
        eventData.addData(type: .xpGrantAmount, value: xpReward.amount)
    }
}

class CurrencyRewardHandler: RewardHandler {
    func processReward(_ reward: any SpecificReward, in context: EventContext, eventData: inout EventData) {
        guard let currencyReward = reward as? CurrencySpecificReward,
              let walletSystem = context.getSystem(ofType: WalletSystem.self) else {
            return
        }

        walletSystem.addCurrencyToAll(currencyReward.currency, amount: currencyReward.amount)
        eventData.addData(type: .currencyGrant, value: currencyReward.currency)
        eventData.addData(type: .currencyGrantAmount, value: currencyReward.amount)
    }
}

class ItemRewardHandler: RewardHandler {
    func processReward(_ reward: any SpecificReward, in context: EventContext, eventData: inout EventData) {
        guard let itemReward = reward as? ItemSpecificReward,
              let inventorySystem = context.getSystem(ofType: InventorySystem.self) else {
            return
        }

        let newItem = inventorySystem.createItem(type: itemReward.itemType, quantity: itemReward.quantity)
        inventorySystem.addItem(newItem)
        eventData.addData(type: .itemGrant, value: itemReward.itemType)
        eventData.addData(type: .itemGrantQuantity, value: itemReward.quantity)
    }
}
