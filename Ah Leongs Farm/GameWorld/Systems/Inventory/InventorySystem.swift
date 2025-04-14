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
}
