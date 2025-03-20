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
        for rewardItem in reward.rewards {
            switch rewardItem {
            case .xp(let amount):
                if let levelSystem = context.getSystem(ofType: LevelSystem.self) {
                    levelSystem.addXP(Float(amount))
                    eventData.addData(type: .xpGrantAmount, value: amount)
                }

            case .currency(let type, let amount):
                if let walletSystem = context.getSystem(ofType: WalletSystem.self) {
                    walletSystem.addCurrencyToAll(type, amount: Double(amount))
                    eventData.addData(type: .currencyGrant, value: type)
                }

            case .item(let itemType, let quantity):
                // TODO: Add items to inventory
                break
            }
        }
        return eventData
    }
}
