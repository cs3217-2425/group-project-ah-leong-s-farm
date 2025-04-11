//
//  ItemFactory.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 28/3/25.
//

class ItemFactory {
    static func createBokChoySeed() -> Entity {
        setupComponents(BokChoy.createSeed())
    }

    static func createBokChoyHarvested() -> Entity {
        setupComponents(BokChoy.createHarvested())
    }

    static func createAppleSeed() -> Entity {
        setupComponents(Apple.createSeed())
    }

    static func createAppleHarvested() -> Entity {
        setupComponents(Apple.createHarvested())
    }

    static func createPotatoSeed() -> Entity {
        setupComponents(Potato.createSeed())
    }

    static func createPotatoHarvested() -> Entity {
        setupComponents(Potato.createHarvested())
    }

    static func createFertiliser() -> Entity {
        setupComponents(Fertiliser())
    }

    static func createPremiumFertiliser() -> Entity {
        setupComponents(PremiumFertiliser())
    }

    private static func setupComponents(_ entity: Entity) -> Entity {
        entity.attachComponent(ItemComponent())
        entity.attachComponent(SellComponent())
        return entity
    }
}
