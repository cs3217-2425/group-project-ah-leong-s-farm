//
//  ItemDisplayService.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 30/3/25.
//

struct ItemDisplayMetadata {
    let displayName: String
    let imageName: String
}

protocol ItemDisplayService {
    func getDisplayName(for entity: Entity) -> String
    func getImageName(for entity: Entity) -> String
    func getMetadata(for entity: Entity) -> ItemDisplayMetadata
}

class GameItemDisplayService: ItemDisplayService {
    private let classToMetadata: [String: ItemDisplayMetadata]

    init() {
        classToMetadata = [
            "BokChoy": ItemDisplayMetadata(displayName: "Bokchoy", imageName: "bokchoy_harvested"),
            "BokChoySeed": ItemDisplayMetadata(displayName: "Bokchoy seed", imageName: "bokchoy_seed"),
            "Apple": ItemDisplayMetadata(displayName: "Apple", imageName: "apple_harvested"),
            "AppleSeed": ItemDisplayMetadata(displayName: "Apple seed", imageName: "apple_seed"),
            "Potato": ItemDisplayMetadata(displayName: "Potato", imageName: "potato_harvested"),
            "PotatoSeed": ItemDisplayMetadata(displayName: "Potato seed", imageName: "potato_seed"),
            "Fertiliser": ItemDisplayMetadata(displayName: "Fertiliser", imageName: "fertiliser"),
            "PremiumFertiliser": ItemDisplayMetadata(displayName: "Premium fertiliser", imageName: "premium_fertiliser")
        ]
    }

    func getMetadata(for entity: Entity) -> ItemDisplayMetadata {
        let className = String(describing: type(of: entity))

        if entity.getComponentByType(ofType: SeedComponent.self) != nil {
            if let metadata = classToMetadata[className + "Seed"] {
                return metadata
            }
        }

        if entity.getComponentByType(ofType: HarvestedComponent.self) != nil {
            if let metadata = classToMetadata[className + "Harvested"] {
                return metadata
            }
        }

        return classToMetadata[className] ?? ItemDisplayMetadata(
            displayName: "Unknown \(className)",
            imageName: "unknown_item"
        )
    }

    func getDisplayName(for entity: Entity) -> String {
        getMetadata(for: entity).displayName
    }

    func getImageName(for entity: Entity) -> String {
        getMetadata(for: entity).imageName
    }
}
