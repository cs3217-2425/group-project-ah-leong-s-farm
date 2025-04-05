//
//  HarvestCropEvent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 5/4/25.
//

struct HarvestCropEvent: GameEvent {
    let row: Int
    let column: Int

    func execute(in context: any EventContext, queueable: any EventQueueable) -> (any EventData)? {
        guard let cropSystem = context.getSystem(ofType: CropSystem.self) else {
            return nil
        }

        guard let harvestedCrop = cropSystem.harvestCrop(row: row, column: column) else {
            return nil
        }

        guard let cropComponent = harvestedCrop.component(ofType: CropComponent.self) else {
            return nil
        }

        // Set harvested quantity to 1 for now
        let harvestedQuantity = 1

        return HarvestCropEventData(type: cropComponent.cropType, quantity: harvestedQuantity)
    }
}
