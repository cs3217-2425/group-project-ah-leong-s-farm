//
//  HarvestCropEvent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 5/4/25.
//

struct HarvestCropEvent: GameEvent {
    let row: Int
    let column: Int

    private let ENERGY_USAGE = 1
    private let XP_AMOUNT: Float = 10.0

    func execute(in context: any EventContext, queueable: any EventQueueable) -> (any EventData)? {
        guard let cropSystem = context.getSystem(ofType: CropSystem.self),
              let energySystem = context.getSystem(ofType: EnergySystem.self),
              let levelSystem = context.getSystem(ofType: LevelSystem.self),
              let inventorySystem = context.getSystem(ofType: InventorySystem.self),
              let marketSystem = context.getSystem(ofType: MarketSystem.self) else {
            return nil
        }

        guard energySystem.getCurrentEnergy(of: .base) >= ENERGY_USAGE else {
            return nil
        }

        guard let harvestedCrop = cropSystem.harvestCrop(row: row, column: column),
              let cropComponent = harvestedCrop.getComponentByType(ofType: CropComponent.self) else {
            return nil
        }

        // Set harvested quantity to 1 for now
        let harvestedQuantity = 1

        energySystem.useEnergy(of: .base, amount: ENERGY_USAGE)
        levelSystem.addXP(XP_AMOUNT)
        inventorySystem.addItem(harvestedCrop)
        marketSystem.addEntityToSellMarket(entity: harvestedCrop)

        return HarvestCropEventData(type: cropComponent.cropType, quantity: harvestedQuantity)
    }
}
