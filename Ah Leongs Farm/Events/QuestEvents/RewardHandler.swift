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
        for currencyType in currencyReward.currencies.keys {
            guard let amount = currencyReward.currencies[currencyType] else {
                fatalError("Failed to get value for \(currencyType).")
            }
            walletSystem.addCurrencyToAll(currencyType, amount: amount)
            eventData.addData(type: .currencyGrant, value: currencyType)
            eventData.addData(type: .currencyTransactionAmount, value: amount)
        }

    }
}

class ItemRewardHandler: RewardHandler {
    func processReward(_ reward: any SpecificReward, in context: EventContext, eventData: inout EventData) {
        guard let itemReward = reward as? ItemSpecificReward,
              let inventorySystem = context.getSystem(ofType: InventorySystem.self) else {
            return
        }

        for itemType in itemReward.itemTypes.keys {
            guard let quantity = itemReward.itemTypes[itemType] else {
                fatalError("Failed to get value for \(itemType)")
            }
            inventorySystem.addItem(type: itemType, quantity: quantity)
            eventData.addData(type: .itemGrant, value: itemType)
            eventData.addData(type: .itemGrantQuantity, value: quantity)
        }
    }
}
