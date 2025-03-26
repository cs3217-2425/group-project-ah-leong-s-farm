//
//  InventorySystem.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 17/3/25.
//

import Foundation
import GameplayKit

class InventorySystem: ISystem {
    unowned var manager: EntityManager?

    private var items: [ItemComponent] {
        manager?.getAllComponents(ofType: ItemComponent.self) ?? []
    }

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    // Checks if an item is stackable and an ItemComponent of the type exists,
    // then increment its quantity.
    // Else create a new item
    func addItem(type: ItemType,
                 quantity: Int) {
        if type.isStackable {
            for existingItem in items where existingItem.itemType == type {
                existingItem.add(quantity)
                return
            }
        }

        let itemEntity = Item(type: type, quantity: quantity)
        manager?.addEntity(itemEntity)
    }

    /// Removes the entity that contains the ItemComponent
    func removeItem(_ component: ItemComponent) {
        guard let manager = manager,
              let itemEntity = component.entity else {
            return
        }
        manager.removeEntity(itemEntity)
    }

    /// Removes an item of a specific type, if and only if there is sufficient quantity and it exists.
    /// - Returns: True if the item is removed successfully, false otherwise.
    @discardableResult
    func removeItem(of type: ItemType, amount: Int = 1) -> Bool {
        guard let manager = manager else {
            return false
        }

        for existingItem in items {

            guard existingItem.itemType == type else {
                continue
            }

            guard existingItem.hasSufficientQuantity(amount) else {
                return false
            }

            existingItem.remove(amount)

            if existingItem.quantity == 0 {
                self.removeItem(existingItem)
            }

            return true
        }

        return false
    }

    func hasItem(_ item: ItemComponent) -> Bool {
        items.contains(item)
    }

    func getAllComponents() -> [ItemComponent] {
        items
    }

    func getNumberOfItems(of type: ItemType) -> Int {

        var count = 0
        for item in items where item.itemType == type {
            count += item.quantity
        }
        return count
    }
}
