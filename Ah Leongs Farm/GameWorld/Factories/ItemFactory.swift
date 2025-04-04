//
//  ItemFactory.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 28/3/25.
//

import Foundation
import GameplayKit

class ItemFactory {
    static let itemToInitialisers: [ItemType: () -> GKEntity?] = [
        .bokChoySeed: {
            setupComponents(createSeed(for: .bokChoy), type: .bokChoySeed)
            },
        .appleSeed: {
            setupComponents(createSeed(for: .apple), type: .appleSeed)
            },
        .potatoSeed: {
            setupComponents(createSeed(for: .potato), type: .potatoSeed)
             },
        .fertiliser: {
            setupComponents(Fertiliser(), type: .fertiliser)
            },
        .premiumFertiliser: {
            setupComponents(PremiumFertiliser(), type: .premiumFertiliser)
            }
    ]

    private static let cropToSeedInitialisers: [CropType: () -> GKEntity] = [
        .bokChoy: { BokChoy.createSeed() },
        .apple: { Apple.createSeed() },
        .potato: { Potato.createSeed() }
    ]

    private static func createSeed(for crop: CropType) -> GKEntity {
        guard let seedInitialiser = cropToSeedInitialisers[crop] else {
            fatalError("Seed initialiser for \(crop) not defined!")
        }
        return seedInitialiser()
    }

    private static func setupComponents(_ entity: GKEntity, type: ItemType) -> GKEntity {
        entity.addComponent(ItemComponent(itemType: type))

        // Add SellComponent if the market can sell that item
        if MarketInformation.sellableItems.contains(type) {
            entity.addComponent(SellComponent(itemType: type))
        }
        return entity
    }
}
