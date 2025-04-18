//
//  LevelUpEvent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 16/4/25.
//

struct LevelUpEvent: GameEvent {
    func execute(in context: EventContext, queueable: EventQueueable) -> EventData? {
        guard let upgradeSystem = context.getSystem(ofType: UpgradeSystem.self),
              let levelSystem = context.getSystem(ofType: LevelSystem.self) else {
            return nil
        }

        upgradeSystem.addUpgradePoint()
        let newLevel = levelSystem.getCurrentLevel()
        return LevelUpEventData(newLevel: newLevel)
    }
}
