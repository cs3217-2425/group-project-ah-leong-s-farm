//
//  RewardHandlerFactory.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 22/3/25.
//

// Strategy factory - maps reward types to their handlers
class RewardHandlerFactory {
    private static var strategies: [RewardType: RewardHandler] = [
        .xp: XPRewardHandler(),
        .currency: CurrencyRewardHandler(),
        .item: ItemRewardHandler()
    ]

    static func getStrategy(for rewardType: RewardType) -> RewardHandler {
        // Return the existing strategy or create a new one if needed
        guard let strategy = strategies[rewardType] else {
            fatalError("Strategy not registered for \(rewardType)")
        }
        return strategy
    }
}
