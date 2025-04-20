//
//  RazePlotEvent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 4/4/25.
//

struct RazePlotEvent: GameEvent {
    let row: Int
    let column: Int

    func execute(in context: any EventContext, queueable: any EventQueueable) -> (any EventData)? {
        guard let gridSystem = context.getSystem(ofType: GridSystem.self),
              let soundSystem = context.getSystem(ofType: SoundSystem.self),
              let upgradeSystem = context.getSystem(ofType: UpgradeSystem.self) else {
            return nil
        }

        let isSuccessfullyRazed = gridSystem.razePlot(row: row, column: column)
        upgradeSystem.addUpgradePoint()
        soundSystem.playSoundEffect(named: "raze-plot")

        return RazePlotEventData(row: row, column: column, isSuccessfullyRazed: isSuccessfullyRazed)
    }
}
