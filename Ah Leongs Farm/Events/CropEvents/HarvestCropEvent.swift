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

        guard let result = cropSystem.harvestCrop(row: row, column: column) else {
            return nil
        }

        let cropType = result.type
        let harvestedCrops = result.crops

        energySystem.useEnergy(of: .base, amount: ENERGY_USAGE)
        levelSystem.addXP(XP_AMOUNT)
        inventorySystem.addItemsToInventory(harvestedCrops)
        marketSystem.addEntitiesToSellMarket(entities: harvestedCrops)

        // remove this after crop type is removed!!
        guard let cropComponent = harvestedCrops.first?.component(ofType: CropComponent.self) else {
            fatalError("Cannot get crop component from harvested crops")
        }

        return HarvestCropEventData(type: cropComponent.cropType, quantity: harvestedCrops.count)
    }
}
