//
//  ItemType.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 12/4/25.
//

enum ItemTypeNew: Hashable {
    case bokChoyHarvested
    case bokChoySeed
    case appleSeed
    case appleHarvested
    case potatoSeed
    case potatoHarvested
    case fertiliser
    case premiumFertiliser

    static func getItemTypeToEntities(from manager: EntityManager) -> [ItemTypeNew: [Entity]] {
        let itemTypeToEntities: [ItemTypeNew: [Entity]] = [
            .bokChoySeed: manager
                .getEntities(withComponentType: SeedComponent.self)
                .filter { $0.type == BokChoy.type },
            .bokChoyHarvested: manager
                .getEntities(withComponentType: HarvestedComponent.self)
                .filter { $0.type == BokChoy.type },
            .appleSeed: manager
                .getEntities(withComponentType: SeedComponent.self)
                .filter { $0.type == Apple.type },
            .appleHarvested: manager
                .getEntities(withComponentType: HarvestedComponent.self)
                .filter { $0.type == Apple.type },
            .potatoSeed: manager
                .getEntities(withComponentType: SeedComponent.self)
                .filter { $0.type == Potato.type },
            .potatoHarvested: manager
                .getEntities(withComponentType: HarvestedComponent.self)
                .filter { $0.type == Potato.type },
            .fertiliser: manager
                .getAllEntities()
                .filter { $0.type == Fertiliser.type },
            .premiumFertiliser: manager
                .getAllEntities()
                .filter { $0.type == PremiumFertiliser.type }
        ]
        return itemTypeToEntities
    }

    static func getItemTypeToInitialisers() -> [ItemTypeNew: () -> Entity] {
        .bokChoySeed: 
    }
}
