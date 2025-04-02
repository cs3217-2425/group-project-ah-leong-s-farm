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

        guard let inventorySystem = context.getSystem(ofType: InventorySystem.self) else {
            return nil
        }

        guard let inventoryComponent = inventorySystem.getAllComponents()
            .first(where: { seedToCrop[$0.itemType] == cropType }) else {
            return nil
        }

        guard let crop = inventoryComponent.entity as? Crop else {
            return nil
        }

        let row = Int(position.x)
        let column = Int(position.y)

        let isSuccessfullyPlanted = cropSystem.plantCrop(crop: crop, row: row, column: column)

        return PlantCropEventData(cropType: cropType, isSuccessfullyPlanted: isSuccessfullyPlanted)
    }
}
