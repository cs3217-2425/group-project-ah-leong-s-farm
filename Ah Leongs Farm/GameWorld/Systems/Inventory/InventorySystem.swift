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

    func addItem(_ itemToAdd: Entity) {
        guard let itemComponent = itemToAdd.getComponentByType(ofType: ItemComponent.self) else {
            return
        }

        manager?.addEntity(itemToAdd)

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

    func hasItem(of type: Entity.Type) -> Bool {
        items.contains(where: { Swift.type(of:$0.ownerEntity) == type })
    }

    func getAllComponents() -> [ItemComponent] {
        items
    }
}
