//
//  ItemComponent.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 17/3/25.
//

import Foundation

class ItemComponent: ComponentAdapter {
    var quantity: Int

    init(quantity: Int = 1) {
        self.quantity = quantity
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    func add(_ amount: Int) {
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
