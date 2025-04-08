//
//  BuyComponent 2.swift
//  Ah Leongs Farm
//
//  Created by proglab on 29/3/25.
//

import Foundation
class SellComponent: ComponentAdapter {
    let itemType: ItemType

    init(itemType: ItemType) {
        self.itemType = itemType
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
