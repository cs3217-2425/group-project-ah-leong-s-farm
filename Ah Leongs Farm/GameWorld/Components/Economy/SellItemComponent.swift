//
//  BuyComponent 2.swift
//  Ah Leongs Farm
//
//  Created by proglab on 29/3/25.
//

import GameplayKit

class SellItemComponent: GKComponent {
    let cost: Double
    let itemType: ItemType

    init(cost: Double, itemType: ItemType) {
        self.cost = cost
        self.itemType = itemType
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
