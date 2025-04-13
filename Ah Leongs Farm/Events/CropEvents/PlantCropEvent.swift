//
//  PlantSeedEvent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 2/4/25.
//

import Foundation

struct PlantCropEvent: GameEvent {
    let row: Int
    let column: Int

    private let ENERGY_USAGE = 1
    private let XP_AMOUNT: Float = 10.0

    let cropType: CropType

    func execute(in context: any EventContext, queueable: any EventQueueable) -> (any EventData)? {
        guard let cropSystem = context.getSystem(ofType: CropSystem.self) else {
            return nil
        }

        guard let crop = cropSystem.getAllSeedEntities(for: cropType).first else {
            return nil
        }

        guard let energySystem = context.getSystem(ofType: EnergySystem.self) else {
            return nil
        }

        guard let levelSystem = context.getSystem(ofType: LevelSystem.self) else {
            return nil
        }

        guard energySystem.getCurrentEnergy() >= ENERGY_USAGE else {
            return nil
        }
        let isSuccessfullyPlanted = cropSystem.plantCrop(crop: crop, row: row, column: column)

        if isSuccessfullyPlanted {
            energySystem.useEnergy(amount: ENERGY_USAGE)
            levelSystem.addXP(XP_AMOUNT)
        }

        return PlantCropEventData(
            row: row,
            column: column,
            cropType: cropType,
            isSuccessfullyPlanted: isSuccessfullyPlanted
        )
    }
}
