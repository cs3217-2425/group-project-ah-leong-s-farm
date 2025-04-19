//
//  PlaceSolarPanelEvent.swift
//  Ah Leongs Farm
//
//  Created by proglab on 16/4/25.
//

struct PlaceSolarPanelEvent: GameEvent {
    let row: Int
    let column: Int

    func execute(in context: any EventContext, queueable: any EventQueueable) -> (any EventData)? {
        guard let solarPanelSystem = context.getSystem(ofType: SolarPanelSystem.self),
              let energySystem = context.getSystem(ofType: EnergySystem.self),
              let soundSystem = context.getSystem(ofType: SoundSystem.self),
              let inventorySystem = context.getSystem(ofType: InventorySystem.self) else {
            return nil
        }

        guard let solarPanel = context
            .getEntitiesOfType(SolarPanel.type)
            .first(where: { entity in
                guard let panel = entity as? SolarPanel else {
                    return false
                }
                return panel.getComponentByType(ofType: ItemComponent.self) != nil
            }) as? SolarPanel else {
            return nil
        }

        guard let energyCapBoostComponent = solarPanel.getComponentByType(ofType: EnergyCapBoostComponent.self) else {
            return nil
        }

        let isSuccessfullyPlaced = solarPanelSystem.placeSolarPanel(solarPanel: solarPanel, row: row, column: column)

        if isSuccessfullyPlaced {
            inventorySystem.removeItemFromInventory(solarPanel)
            energySystem.increaseMaxEnergy(of: energyCapBoostComponent.type, by: energyCapBoostComponent.boost)
            soundSystem.playSoundEffect(named: "add-solar")
        }

        return nil
    }
}
