//
//  WaterPlotEvent.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 14/4/25.
//

struct WaterPlotEvent: GameEvent {
    let row: Int
    let column: Int

    func execute(in context: any EventContext, queueable: any EventQueueable) -> (any EventData)? {
        guard let gridSystem = context.getSystem(ofType: GridSystem.self),
              let soundSystem = context.getSystem(ofType: SoundSystem.self),
              let energySystem = context.getSystem(ofType: EnergySystem.self) else {
            return nil
        }

        guard energySystem.getCurrentEnergy(of: .base) > 0 else {
            return InsufficientEnergyErrorEventData(message: "Not enough energy to water crop!")
        }

        gridSystem.waterPlot(row: row, column: column)
        energySystem.useEnergy(of: .base, amount: 1)
        soundSystem.playSoundEffect(named: "water")

        return WaterPlotEventData(row: row, column: column, isSuccessfullyWatered: true)
    }
}
