//
//  PlaceSolarPanelEvent.swift
//  Ah Leongs Farm
//
//  Created by proglab on 16/4/25.
//

struct RemoveSolarPanelEvent: GameEvent {
    let row: Int
    let column: Int

    func execute(in context: any EventContext, queueable: any EventQueueable) -> (any EventData)? {
        guard let solarPanelSystem = context.getSystem(ofType: SolarPanelSystem.self),
              let energySystem = context.getSystem(ofType: EnergySystem.self),
              let soundSystem = context.getSystem(ofType: SoundSystem.self),
              let inventorySystem = context.getSystem(ofType: InventorySystem.self) else {
            return nil
        }

        guard let solarPanel = solarPanelSystem.removeSolarPanel(row: row, column: column) else {
            return nil
        }

        guard let energyCapBoostComponent = solarPanel.getComponentByType(ofType: EnergyCapBoostComponent.self) else {
            return nil
        }

        inventorySystem.addItemToInventory(solarPanel)

        energySystem.decreaseMaxEnergy(of: energyCapBoostComponent.type, by: energyCapBoostComponent.boost)
        soundSystem.playSoundEffect(named: "remove-solar")

        return nil
    }
}
