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
            createSeed(for: .bokChoy)
                .setupSellComponent()
        },
        .appleSeed: {
            createSeed(for: .apple)
                .setupSellComponent()
        },
        .potatoSeed: {
            createSeed(for: .potato)
                .setupSellComponent()
        },
        .fertiliser: {
            Fertiliser().setupSellComponent()
        },
        .premiumFertiliser: {
            PremiumFertiliser().setupSellComponent()
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
}
