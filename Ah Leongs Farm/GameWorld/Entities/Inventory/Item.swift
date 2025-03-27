//
//  Item.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 25/3/25.
//

import GameplayKit

class Item: GKEntity {
    init(type: ItemType, quantity: Int) {
        super.init()
        self.addComponent(ItemComponent(itemType: type, quantity: quantity))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
