//
//  ItemFactory.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 28/3/25.
//

class ItemFactory {
    static let itemToInitialisers: [ItemType: () -> (Entity)?] = [
        .bokChoySeed: {
            setupComponents(createSeed(for: .bokChoy), type: .bokChoySeed)
            },
        .appleSeed: {
            setupComponents(createSeed(for: .apple), type: .appleSeed)
            },
        .potatoSeed: {
            setupComponents(createSeed(for: .potato), type: .potatoSeed)
             },
        .appleHarvested: {
            setupComponents(createHarvested(for: .apple), type: .appleHarvested)
            },
        .bokChoyHarvested: {
            setupComponents(createHarvested(for: .bokChoy), type: .bokChoyHarvested)
            },
        .potatoHarvested: {
            setupComponents(createHarvested(for: .potato), type: .potatoHarvested)
            },
        .fertiliser: {
            setupComponents(Fertiliser(), type: .fertiliser)
            },
        .premiumFertiliser: {
            setupComponents(PremiumFertiliser(), type: .premiumFertiliser)
            }
    ]

    private static let cropToSeedInitialisers: [CropType: () -> Entity] = [
        .bokChoy: { BokChoy.createSeed() },
        .apple: { Apple.createSeed() },
        .potato: { Potato.createSeed() }
    ]

    private static func createSeed(for crop: CropType) -> Entity {
        guard let seedInitialiser = cropToSeedInitialisers[crop] else {
            fatalError("Seed initialiser for \(crop) not defined!")
        }
        return seedInitialiser()
    }
    private static let cropToHarvestedInitialisers: [CropType: () -> Entity] = [
        .bokChoy: { BokChoy.createHarvested() },
        .apple: { Apple.createHarvested() },
        .potato: { Potato.createHarvested() }
    ]

    private static func createHarvested(for crop: CropType) -> Entity {
        guard let harvestedInitialiser = cropToHarvestedInitialisers[crop] else {
            fatalError("Harvested initialiser for \(crop) not defined!")
        }
        return harvestedInitialiser()
    }

    private static func setupComponents(_ entity: Entity, type: ItemType) -> Entity {
        entity.attachComponent(ItemComponent(itemType: type))

        // Add SellComponent if the market can sell that item
        if MarketInformation.sellableItems.contains(type) {
            entity.attachComponent(SellComponent(itemType: type))
        }
        return entity
    }
}
