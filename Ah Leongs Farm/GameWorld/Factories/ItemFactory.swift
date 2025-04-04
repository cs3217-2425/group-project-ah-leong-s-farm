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
            createSeed(for: .bokChoy).flatMap { setupComponents($0, type: .bokChoySeed) }
            },
        .appleSeed: {
            createSeed(for: .apple).flatMap { setupComponents($0, type: .appleSeed) }
            },
        .potatoSeed: {
            createSeed(for: .potato).flatMap { setupComponents($0, type: .potatoSeed) }
             },
        .appleHarvested: {
            createHarvested(for: .apple).flatMap { setupComponents($0, type: .appleHarvested) }
            },
        .bokChoyHarvested: {
            createHarvested(for: .bokChoy).flatMap { setupComponents($0, type: .bokChoyHarvested) }
            },
        .potatoHarvested: {
            createHarvested(for: .potato).flatMap { setupComponents($0, type: .potatoHarvested) }
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

    private static let cropToHarvestedInitialisers: [CropType: () -> GKEntity] = [
        .bokChoy: { BokChoy.createHarvested() },
        .apple: { Apple.createHarvested() },
        .potato: { Potato.createHarvested() }
    ]

    private static func createSeed(for crop: CropType) -> GKEntity? {
        cropToSeedInitialisers[crop]?()
    }

    private static func createHarvested(for crop: CropType) -> GKEntity? {
        cropToHarvestedInitialisers[crop]?()
    }

    private static func addItemComponent(_ entity: GKEntity, type: ItemType) -> GKEntity {
        entity.addComponent(ItemComponent(itemType: type))
        return entity
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
