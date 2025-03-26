//
//  RewardHandler.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 22/3/25.
//

protocol RewardHandler {
    func processReward(_ reward: any SpecificReward, in context: EventContext, eventData: inout RewardGrantEventData)
}

class XPRewardHandler: RewardHandler {
    func processReward(_ reward: any SpecificReward, in context: EventContext, eventData: inout RewardGrantEventData) {
        guard let xpReward = reward as? XPSpecificReward,
              let levelSystem = context.getSystem(ofType: LevelSystem.self) else {
            return
        }

        levelSystem.addXP(xpReward.amount)

        eventData.xpGrantAmount += Int(xpReward.amount)
    }
}

class CurrencyRewardHandler: RewardHandler {
    func processReward(_ reward: any SpecificReward, in context: EventContext, eventData: inout RewardGrantEventData) {
        guard let currencyReward = reward as? CurrencySpecificReward,
              let walletSystem = context.getSystem(ofType: WalletSystem.self) else {
            return
        }

        for currencyType in currencyReward.currencies.keys {
            guard let amount = currencyReward.currencies[currencyType] else {
                fatalError("Failed to get value for \(currencyType).")
            }
            walletSystem.addCurrencyToAll(currencyType, amount: amount)

            // Update the event data with the currency grants
            eventData.currencyGrants[currencyType] = (eventData.currencyGrants[currencyType] ?? 0) + amount
        }
    }
}

class ItemRewardHandler: RewardHandler {
    func processReward(_ reward: any SpecificReward, in context: EventContext, eventData: inout RewardGrantEventData) {
        guard let itemReward = reward as? ItemSpecificReward,
              let inventorySystem = context.getSystem(ofType: InventorySystem.self) else {
            return
        }

        for itemType in itemReward.itemTypes.keys {
            guard let quantity = itemReward.itemTypes[itemType] else {
                fatalError("Failed to get value for \(itemType)")
            }
            let newItem = inventorySystem.createItem(type: itemType, quantity: quantity)
            inventorySystem.addItem(newItem)

            eventData.itemGrants[itemType] = (eventData.itemGrants[itemType] ?? 0) + quantity
        }
    }
}
