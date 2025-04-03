//
//  GKEntity+SellComponent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 3/4/25.
//

import GameplayKit
extension GKEntity {
    func setupSellComponent() -> GKEntity {
        guard let itemComponent = self.component(ofType: ItemComponent.self) else {
            return self
        }
        let itemType = itemComponent.itemType
        if MarketInformation.sellableItems.contains(itemType) {
            self.addComponent(SellComponent(itemType: itemType))
        }
        return self
    }
}
