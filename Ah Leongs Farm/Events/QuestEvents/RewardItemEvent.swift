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
        guard let inventorySystem = context.getSystem(ofType: InventorySystem.self) else {
            return nil
        }
        for (type, quantity) in itemTypes {
            inventorySystem.addItems(ItemFactory.createItems(type: type, quantity: quantity))
            eventData.itemGrants[type] = quantity
        }
        return eventData
    }
}
