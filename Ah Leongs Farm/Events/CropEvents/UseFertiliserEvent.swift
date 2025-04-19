//
//  UseFertiliserEvent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 15/4/25.
//

struct UseFertiliserEvent: GameEvent {
    let row: Int
    let column: Int
    let fertiliserType: EntityType

    private let ENERGY_USAGE = 1

    func execute(in context: any EventContext, queueable: any EventQueueable) -> (any EventData)? {
        guard let soilSystem = context.getSystem(ofType: SoilSystem.self),
              let energySystem = context.getSystem(ofType: EnergySystem.self),
              let gridSystem = context.getSystem(ofType: GridSystem.self) else {
            return nil
        }

        guard energySystem.getCurrentEnergy(of: .base) >= ENERGY_USAGE else {
            return NotEnoughEnergyErrorEventData(message: "Not enough energy to fertilise!")
        }

        let fertilisers = context.getEntitiesOfType(fertiliserType)
        guard let fertiliser = fertilisers.first as? Fertiliser else {
            return nil
        }

        guard let plot = gridSystem.getPlot(row: row, column: column) else {
            return nil
        }

        let isSuccessful = soilSystem.improveSoilQuality(plot: plot,
                                                         improvementAmount: fertiliser.soilImprovementAmount)

        if isSuccessful {
            energySystem.useEnergy(of: .base, amount: ENERGY_USAGE)

            context.removeEntity(fertiliser)

        }

        return UseFertiliserEventData(
            row: row,
            column: column,
            fertiliserType: fertiliserType,
            isSuccessful: isSuccessful
        )
    }
}
