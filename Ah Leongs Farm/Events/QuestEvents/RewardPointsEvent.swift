//
//  RewardPointsEvent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/4/25.
//

class RewardPointsEvent: GameEvent {
    private let amount: Int

    init(amount: Int) {
        self.amount = amount
    }

    func execute(in context: EventContext, queueable: EventQueueable) -> EventData? {
        guard let upgradeSystem = context.getSystem(ofType: UpgradeSystem.self) else {
            return nil
        }
        upgradeSystem.addUpgradePoint(amount)
        return nil
    }
}
