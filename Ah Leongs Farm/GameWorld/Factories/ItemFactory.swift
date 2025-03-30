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
        .bokChoySeed: { createSeed(for: .bokChoy) },
        .appleSeed: { createSeed(for: .apple) },
        .potatoSeed: { createSeed(for: .potato) }
    ]

    private static let cropToSeedInitialisers: [CropType: () -> GKEntity] = [
        .bokChoy: { BokChoy.createSeed() },
        .apple: { Apple.createSeed() },
        .potato: { Potato.createSeed() }
    ]

    private static func createSeed(for crop: CropType) -> GKEntity? {
        cropToSeedInitialisers[crop]?()
    }
}
