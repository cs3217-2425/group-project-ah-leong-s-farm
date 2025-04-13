//
//  RewardItemEvent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 29/3/25.
//

class RewardItemEvent: GameEvent {
    private let itemTypes: [ItemType: Int]

    init(itemTypes: [ItemType: Int]) {
        self.itemTypes = itemTypes
    }

    func execute(in context: EventContext, queueable: EventQueueable) -> EventData? {
        var eventData = ItemGrantEventData()
        guard let inventorySystem = context.getSystem(ofType: InventorySystem.self) else {
            return nil
        }
        for (type, quantity) in itemTypes {
            guard let itemInitialiser = ItemFactory.itemToInitialisers[type] else {
                continue
            }
            for _ in 0..<quantity {
                inventorySystem.addItem(itemInitialiser())
            }
            eventData.itemGrants[type] = quantity
        }
        return eventData
    }
}
