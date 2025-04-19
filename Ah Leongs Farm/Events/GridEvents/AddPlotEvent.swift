//
//  AddPlotEvent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 2/4/25.
//

import Foundation

struct AddPlotEvent: GameEvent {
    let row: Int
    let column: Int

    private let ENERGY_USAGE = 1

    func execute(in context: any EventContext, queueable: any EventQueueable) -> (any EventData)? {
        guard let gridSystem = context.getSystem(ofType: GridSystem.self),
              let upgradeSystem = context.getSystem(ofType: UpgradeSystem.self),
              let energySystem = context.getSystem(ofType: EnergySystem.self),
              upgradeSystem.getUpgradePoints() > 0 else {
            return nil
        }

        guard energySystem.getCurrentEnergy(of: .base) >= ENERGY_USAGE else {
            return NotEnoughEnergyErrorEventData(message: "Not enough energy to add plot!")
        }

        let plot = Plot(position: CGPoint(x: row, y: column))

        let isSuccessfullyAdded = gridSystem.addPlot(plot)
        if isSuccessfullyAdded {
            energySystem.useEnergy(of: .base, amount: 1)
            upgradeSystem.useUpgradePoint()
        }
        return AddPlotEventData(row: row, column: column, isSuccessfullyAdded: isSuccessfullyAdded)
    }
}
