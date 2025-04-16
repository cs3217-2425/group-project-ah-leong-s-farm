//
//  EndTurnEvent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/3/25.
//

struct EndTurnEvent: GameEvent {
    func execute(in context: EventContext, queueable: EventQueueable) -> EventData? {

        guard let turnSystem = context.getSystem(ofType: TurnSystem.self),
              let energySystem = context.getSystem(ofType: EnergySystem.self),
              let cropSystem = context.getSystem(ofType: CropSystem.self),
              let marketSystem = context.getSystem(ofType: MarketSystem.self),
              let gridSystem = context.getSystem(ofType: GridSystem.self) else {
            return nil
        }

        let shouldContinue = turnSystem.incrementTurn()
        energySystem.replenishEnergy(of: .base)
        cropSystem.growCrops()
        marketSystem.resetItemStocks()
        gridSystem.unwaterPlots()

        if !shouldContinue {
            queueable.queueEvent(GameOverEvent())
        }
        return EndTurnEventData()
    }
}
