//
//  ItemComponent.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 17/3/25.
//

import Foundation
import GameplayKit

class ItemComponent: GKComponent {
    let itemType: ItemType
    let stackable: Bool
    var quantity: Int

    init(itemType: ItemType, stackable: Bool) {
        self.itemType = itemType
        self.stackable = stackable
        self.quantity = 1
        super.init()
    }

    required init?(coder: NSCoder) {
        self.itemType = .bokChoySeed
        self.stackable = true
        self.quantity = 1
        super.init(coder: coder)
    }

    func add(_ amount: Int) {
        guard stackable else {
            return
        }

        let total = quantity + amount
        quantity = total
    }
}

enum ItemType {
    case bokChoyHarvested
    case bokChoySeed
}
