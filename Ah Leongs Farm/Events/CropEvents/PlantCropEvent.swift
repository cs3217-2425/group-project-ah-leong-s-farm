//
//  PlantSeedEvent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 2/4/25.
//

import Foundation

struct PlantCropEvent: GameEvent {
    let cropType: CropType
    let plot: Plot

    func execute(in context: any EventContext, queueable: any EventQueueable) -> (any EventData)? {
        guard let cropSystem = context.getSystem(ofType: CropSystem.self) else {
            return nil
        }

        guard let position = plot.component(ofType: PositionComponent.self) else {
            return nil
        }

        guard let crop = cropSystem.getAllSeedEntities(for: cropType).first else {
            return nil
        }

        let row = Int(position.x)
        let column = Int(position.y)

        let isSuccessfullyPlanted = cropSystem.plantCrop(crop: crop, row: row, column: column)

        return PlantCropEventData(cropType: cropType, isSuccessfullyPlanted: isSuccessfullyPlanted)
    }
}
