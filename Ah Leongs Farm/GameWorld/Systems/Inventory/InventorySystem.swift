//
//  InventorySystem.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 17/3/25.
//

import Foundation

class InventorySystem: ISystem {
    unowned var manager: EntityManager?

    private var items: [ItemComponent] {
        manager?.getAllComponents(ofType: ItemComponent.self) ?? []
    }

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func addItemToInventory(_ itemToAdd: Entity) {

        guard isAllowedInInventory(itemToAdd) else {
            print("Entity of type \(itemToAdd.type) is not allowed in inventory.")
            return
        }

        guard itemToAdd.getComponentByType(ofType: ItemComponent.self) == nil else {
            return
        }

        itemToAdd.attachComponent(ItemComponent())
    }

    func addItemsToInventory(_ itemsToAdd: [Entity]) {
        for item in itemsToAdd {
            addItemToInventory(item)
        }
    }

    func removeItem(_ item: ItemComponent) {
        guard let itemToRemove = items.first(where: { $0 == item }) else {
            return
        }

        guard let entity = itemToRemove.ownerEntity else {
            return
        }

        manager?.removeComponent(ofType: ItemComponent.self, from: entity)
    }

    func hasItem(_ item: ItemComponent) -> Bool {
        items.contains(item)
    }

    func hasItem(of type: EntityType) -> Bool {
        items.contains(where: {
            $0.ownerEntity?.type == type
        })
    }

    func getAllComponents() -> [ItemComponent] {
        items
    }

    private func isAllowedInInventory(_ entity: Entity) -> Bool {
        entity is Seed || entity is Crop || entity is Tool
    }
}
