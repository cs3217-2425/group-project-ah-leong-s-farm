//
//  QuestCompletedEvent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/3/25.
//

class QuestCompletedEvent: GameEvent {
    private let reward: Reward

    init(reward: Reward) {
        self.reward = reward
    }

    func execute(in context: EventContext, queueable: EventQueueable) -> EventData? {
        queueable.queueEvent(RewardGrantEvent(reward: reward))
        return nil
    }
}
