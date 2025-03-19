//
//  EndTurnEvent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/3/25.
//

struct EndTurnEvent: GameEvent {
    func execute(in context: EventContext) {
        guard let turnSystem = context.getSystem(ofType: TurnSystem.self),
              let energySystem = context.getSystem(ofType: EnergySystem.self) else {
            return
        }

        let shouldContinue = turnSystem.incrementTurn()
        energySystem.replenishEnergy()

        if !shouldContinue {
            context.queueEvent(GameOverEvent())
        }
    }
}
