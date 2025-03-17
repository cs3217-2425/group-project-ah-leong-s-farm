//
//  InventorySystem.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 17/3/25.
//

import Foundation
import GameplayKit

class InventorySystem: GKComponentSystem<ItemComponent> {
    private var items: [GKEntity]

    override init() {
        items = []
        super.init()
    }

    /// Adds an item to the inventory if and only if it is an item component.
    /// - Returns: True if the item is added successfully, false otherwise.
    @discardableResult
    func addItem(_ itemToAdd: GKEntity) -> Bool {
        guard let item = itemToAdd.component(ofType: ItemComponent.self) else {
            return false
        }

        return false
    }
}
