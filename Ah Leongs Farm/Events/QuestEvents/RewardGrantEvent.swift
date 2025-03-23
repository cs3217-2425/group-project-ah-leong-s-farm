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

            for specificReward in reward.rewards {
                let strategy = RewardHandlerFactory.getStrategy(for: specificReward.type)
                strategy.processReward(specificReward, in: context, eventData: &eventData)
            }

            return eventData
        }
}
