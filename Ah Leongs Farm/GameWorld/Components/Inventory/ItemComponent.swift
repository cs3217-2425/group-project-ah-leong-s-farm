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
    var quantity: Int
    var stackable: Bool {
        itemType.isStackable
    }

    init(itemType: ItemType, quantity: Int = 1) {
        self.itemType = itemType
        self.quantity = quantity
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    func add(_ amount: Int) {
        guard stackable else {
            return
        }

        guard amount >= 0 else {
            return
        }

        let total = quantity + amount
        quantity = total
    }

    func remove(_ amount: Int) {
        guard amount >= 0 else {
            return
        }

        guard amount <= quantity else {
            return
        }

        let newTotal = quantity - amount
        quantity = newTotal
    }

    func hasSufficientQuantity(_ amount: Int) -> Bool {
        quantity >= amount
    }
}

enum ItemType: Hashable {
    case bokChoyHarvested
    case bokChoySeed
    case appleSeed
    case appleHarvested
    case potatoSeed
    case potatoHarvested
    case fertiliser
    case premiumFertiliser

    private struct Properties {
        static let stackable: Set<ItemType> = [
            .bokChoyHarvested, .bokChoySeed, .appleSeed,
            .appleHarvested, .potatoSeed, .potatoHarvested,
            .fertiliser
        ]
    }

    var isStackable: Bool {
        Properties.stackable.contains(self)
    }
}
