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

    // Creates new entities if and only if it exists in the ItemFactory
    func addItem(type: ItemType, quantity: Int) {
        for _ in 0..<quantity {
            guard let factoryEntity = ItemFactory.itemToInitialisers[type], let entity = factoryEntity else {
                return
            }

            manager?.addEntity(entity)
        }
    }

    func hasItem(_ item: ItemComponent) -> Bool {
        items.contains(item)
    }

    func hasItem(of type: ItemType) -> Bool {
        items.contains(where: { $0.itemType == type })
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
