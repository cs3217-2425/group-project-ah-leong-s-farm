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
    let cropType: CropType

    func execute(in context: any EventContext, queueable: any EventQueueable) -> (any EventData)? {
        guard let cropSystem = context.getSystem(ofType: CropSystem.self) else {
            return nil
        }

        guard let crop = cropSystem.getAllSeedEntities(for: cropType).first else {
            return nil
        }

        let isSuccessfullyPlanted = cropSystem.plantCrop(crop: crop, row: row, column: column)

        return PlantCropEventData(
            row: row,
            column: column,
            cropType: cropType,
            isSuccessfullyPlanted: isSuccessfullyPlanted
        )
    }
}
