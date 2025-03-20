//
//  EndTurnEvent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/3/25.
//

struct EndTurnEvent: GameEvent {

    func execute(in context: EventContext) -> EventData? {
        var eventData = EventData(eventType: .endTurn)
        guard let turnSystem = context.getSystem(ofType: TurnSystem.self),
              let energySystem = context.getSystem(ofType: EnergySystem.self) else {
            return nil
        }

        let shouldContinue = turnSystem.incrementTurn()
        eventData.addData(type: .endTurnCount, value: 1)
        energySystem.replenishEnergy()

        if !shouldContinue {
            context.queueEvent(GameOverEvent())
        }
        return eventData
    }
}
