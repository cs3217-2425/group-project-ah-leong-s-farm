//
//  RewardXPEvent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 29/3/25.
//

class RewardXPEvent: GameEvent {
    private let amount: Float

    init(amount: Float) {
        self.amount = amount
    }

    func execute(in context: EventContext, queueable: EventQueueable) -> EventData? {
        var eventData = XPGrantEventData()
        guard let levelSystem = context.getSystem(ofType: LevelSystem.self) else {
            return nil
        }

        levelSystem.addXP(amount)
        eventData.xpGrantAmount += amount

        return eventData
    }
}
