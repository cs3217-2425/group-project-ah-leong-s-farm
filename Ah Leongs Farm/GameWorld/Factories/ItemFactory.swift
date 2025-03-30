//
//  ItemFactory.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 28/3/25.
//

import Foundation
import GameplayKit

class ItemFactory {
    static let itemToInitialisers: [ItemType: GKEntity?] = [
        .bokChoySeed: createSeed(for: .bokChoy).flatMap { addItemComponent($0, type: .bokChoySeed) }
    ]

    private static let cropToSeedInitialisers: [CropType: GKEntity] = [
        .bokChoy: BokChoy.createSeed()
    ]

    private static func createSeed(for crop: CropType) -> GKEntity? {
        cropToSeedInitialisers[crop]
    }

    private static func addItemComponent(_ entity: GKEntity, type: ItemType) -> GKEntity {
        entity.addComponent(ItemComponent(itemType: type))
        return entity
    }
}
