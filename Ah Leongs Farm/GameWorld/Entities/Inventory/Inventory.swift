//
//  Inventory.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 20/3/25.
//

import Foundation
import GameplayKit

class Inventory: GKEntity {
    override init() {
        super.init()
        setUpComponents()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    private func setUpComponents() {
        let inventoryComponent = InventoryComponent()
        addComponent(inventoryComponent)
    }
}
