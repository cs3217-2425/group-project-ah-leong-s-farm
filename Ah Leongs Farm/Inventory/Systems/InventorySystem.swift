//
//  InventorySystem.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 17/3/25.
//

import Foundation
import GameplayKit

class InventorySystem: GKComponentSystem<ItemComponent> {
    private var items: Set<GKEntity>

    override init() {
        items = []
        super.init()
    }

    /// Adds a GKEntity to the inventory if and only if it is an item component.
    /// - Returns: True if the item is added successfully, false otherwise.
    @discardableResult
    func addItem(_ itemToAdd: GKEntity) -> Bool {
        guard let itemComponent = itemToAdd.component(ofType: ItemComponent.self) else {
            return false
        }

        guard itemComponent.quantity > 0 else {
            return false
        }

        if !itemComponent.stackable {
            items.insert(itemToAdd)
            return true
        }

        for existingItem in self.items {
            guard let existingItemComponent = existingItem.component(ofType: ItemComponent.self) else {
                continue
            }

            guard existingItemComponent.itemType == itemComponent.itemType else {
                continue
            }

            existingItemComponent.add(itemComponent.quantity)
            return true
        }

        return false
    }

    func removeItem(_ item: GKEntity) {
        items.remove(item)
    }

    /// Removes an item of a specific type, if and only if there is sufficient quantity and it exists.
    /// - Returns: True if the item is removed successfully, false otherwise.
    @discardableResult
    func removeItem(of type: ItemType, amount: Int = 1) -> Bool {
        for existingItem in self.items {
            guard let existingItemComponent = existingItem.component(ofType: ItemComponent.self) else {
                continue
            }
            
            guard existingItemComponent.itemType == type else {
                continue
            }

            guard existingItemComponent.hasSufficientQuantity(amount) else {
                return false
            }

            existingItemComponent.remove(amount)

            if existingItemComponent.quantity == 0 {
                self.removeItem(existingItem)
            }

            return true
        }

        return false
    }

    func hasItem(_ item: GKEntity) -> Bool {
        items.contains(item)
    }
}
