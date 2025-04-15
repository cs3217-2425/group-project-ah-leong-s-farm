//
//  RewardItemEvent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 29/3/25.
//

class RewardItemEvent: GameEvent {
    private let itemTypes: [EntityType: Int]

    init(itemTypes: [EntityType: Int]) {
        self.itemTypes = itemTypes
    }

    func execute(in context: EventContext, queueable: EventQueueable) -> EventData? {
        var eventData = ItemGrantEventData()

        guard let inventorySystem = context.getSystem(ofType: InventorySystem.self),
              let marketSystem = context.getSystem(ofType: MarketSystem.self) else {
            return nil
        }
        for (type, quantity) in itemTypes {
            let newItems = EntityFactoryRegistry.createMultiple(type: type, quantity: quantity)
            context.addEntities(newItems)
            inventorySystem.addItemsToInventory(newItems)
            marketSystem.addEntitiesToSellMarket(entities: newItems)
            eventData.itemGrants[type] = quantity
        }
        return eventData
    }
}
