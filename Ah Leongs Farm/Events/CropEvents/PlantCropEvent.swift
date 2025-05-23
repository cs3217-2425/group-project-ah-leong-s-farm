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

    let seedType: EntityType

    func execute(in context: any EventContext, queueable: any EventQueueable) -> (any EventData)? {
        guard let cropSystem = context.getSystem(ofType: CropSystem.self) else {
            return nil
        }

        guard let seed = context.getEntitiesOfType(seedType).first as? Seed else {
            return nil
        }

        guard let energySystem = context.getSystem(ofType: EnergySystem.self),
              let levelSystem = context.getSystem(ofType: LevelSystem.self),
              let soundSystem = context.getSystem(ofType: SoundSystem.self) else {
            return nil
        }

        guard energySystem.getCurrentEnergy(of: .base) >= ENERGY_USAGE else {
            return InsufficientEnergyErrorEventData(message: "Not enough energy to plant!")
        }

        if cropSystem.isOccupied(row: row, column: column) {
            return nil
        }

        let crop = seed.toCrop()
        context.addEntity(crop)
        context.removeEntity(seed)

        let isSuccessfullyPlanted = cropSystem.plantCrop(crop: crop, row: row, column: column)

        if isSuccessfullyPlanted {
            energySystem.useEnergy(of: .base, amount: ENERGY_USAGE)
            levelSystem.addXP(XP_AMOUNT)
            soundSystem.playSoundEffect(named: "plant-crop")
        }

        return PlantCropEventData(
            row: row,
            column: column,
            cropType: crop.type,
            isSuccessfullyPlanted: isSuccessfullyPlanted
        )
    }
}
