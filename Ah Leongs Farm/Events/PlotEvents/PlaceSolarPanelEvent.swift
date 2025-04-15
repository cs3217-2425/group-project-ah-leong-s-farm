//
//  PlaceSolarPanelEvent.swift
//  Ah Leongs Farm
//
//  Created by proglab on 16/4/25.
//

struct PlaceSolarPanelEvent: GameEvent {
    let row: Int
    let column: Int

    func execute(in context: any EventContext, queueable: any EventQueueable) -> (any EventData)? {
        guard let solarPanelSystem = context.getSystem(ofType: SolarPanelSystem.self) else {
            return nil
        }

        let solarPanel = SolarPanel()
        let isSuccessfullyPlaced = solarPanelSystem.placeSolarPanel(solarPanel: solarPanel, row: row, column: column)

        if isSuccessfullyPlaced {
            context.addEntity(solarPanel)
        }

        return nil
    }
}
