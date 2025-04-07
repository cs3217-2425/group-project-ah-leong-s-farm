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

    func addItem(type: ItemType, quantity: Int) {
        guard let initialiser = ItemFactory.itemToInitialisers[type] else {
            return
        }
        for _ in 0..<quantity {
            guard let entity = initialiser() else {
                return
            }
            manager?.addEntity(entity)
        }
    }

    func removeItem(_ item: ItemComponent) {
        guard let itemToRemove = items.first(where: { $0 == item }) else {
            return
        }

        guard let entity = itemToRemove.entity else {
            return
        }

        manager?.removeComponent(ofType: ItemComponent.self, from: entity)
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

    func getItemsByQuantity() -> [ItemType: Int] {
        let itemComponents = getAllComponents()

        var typeToQuantity: [ItemType: Int] = [:]
        for itemComponent in itemComponents {
            typeToQuantity[itemComponent.itemType] = typeToQuantity[itemComponent.itemType, default: 0] + 1
        }
        return typeToQuantity
    }

    func getNumberOfItems(of type: ItemType) -> Int {

        var count = 0
        for item in items where item.itemType == type {
            count += item.quantity
        }
        return count
    }
}
