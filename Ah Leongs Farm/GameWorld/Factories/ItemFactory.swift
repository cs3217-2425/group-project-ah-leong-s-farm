//
//  ItemFactory.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 28/3/25.
//

class ItemFactory {
    private static let itemToInitialisers: [EntityType: () -> Entity] = [
        BokChoySeed.type: {
            setupComponents(BokChoySeed())
            },
        AppleSeed.type: {
            setupComponents(AppleSeed())
            },
        PotatoSeed.type: {
            setupComponents(PotatoSeed())
             },
        Apple.type: {
            setupComponents(Apple())
            },
        BokChoy.type: {
            setupComponents(BokChoy())
            },
        Potato.type: {
            setupComponents(Potato())
            },
        Fertiliser.type: {
            setupComponents(Fertiliser())
            },
        PremiumFertiliser.type: {
            setupComponents(PremiumFertiliser())
            }
    ]

    static func createItem(type: EntityType) -> Entity {
        guard let itemInitialiser = itemToInitialisers[type] else {
            fatalError("Item initialiser for \(type) not defined!")
        }
        return itemInitialiser()
    }

    static func createItems(type: EntityType, quantity: Int) -> [Entity] {
        guard let itemInitialiser = itemToInitialisers[type] else {
            fatalError("Item initialiser for \(type) not defined!")
        }
        var items: [Entity] = []
        for _ in 0..<quantity {
            items.append(itemInitialiser())
        }
        return items
    }

    private static func setupComponents(_ entity: Entity) -> Entity {
        entity.attachComponent(ItemComponent())

        // Add SellComponent if the market can sell that item
        if MarketInformation.sellableItems.contains(entity.type) {
            entity.attachComponent(SellComponent())
        }
        return entity
    }
}
