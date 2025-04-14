//
//  ItemFactory.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 28/3/25.
//

class ItemFactory {
    private static let typeToInitialisers: [EntityType: () -> Entity] = [
        BokChoySeed.type: {
            BokChoySeed()
            },
        AppleSeed.type: {
            AppleSeed()
            },
        PotatoSeed.type: {
            PotatoSeed()
             },
        Apple.type: {
            Apple()
            },
        BokChoy.type: {
            BokChoy()
            },
        Potato.type: {
            Potato()
            },
        Fertiliser.type: {
            Fertiliser()
            },
        PremiumFertiliser.type: {
            PremiumFertiliser()
            }
    ]

    static func createItem(type: EntityType) -> Entity {
        guard let entityInitialiser = typeToInitialisers[type] else {
            fatalError("Item initialiser for \(type) not defined!")
        }
        return entityInitialiser()
    }

    static func createItems(type: EntityType, quantity: Int) -> [Entity] {
        guard let entityInitialiser = typeToInitialisers[type] else {
            fatalError("Item initialiser for \(type) not defined!")
        }
        var items: [Entity] = []
        for _ in 0..<quantity {
            items.append(entityInitialiser())
        }
        return items
    }
}
