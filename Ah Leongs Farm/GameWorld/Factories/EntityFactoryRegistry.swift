//
//  EntityFactory.swift
//  Ah Leongs Farm
//
//  Created by proglab on 14/4/25.
//

class EntityFactoryRegistry {
    private static let factories: [EntityFactory.Type] = [
        SeedFactory.self,
        CropFactory.self,
        ToolFactory.self
    ]

    static func createItem(type: EntityType) -> Entity {
        for factory in factories {
            if factory.canCreate(type: type) {
                return factory.create(type: type)
            }
        }
        fatalError("No factory found for type: \(type)")
    }

    static func createItems(type: EntityType, quantity: Int) -> [Entity] {
        for factory in factories {
            if factory.canCreate(type: type) {
                return factory.createMultiple(type: type, quantity: quantity)
            }
        }
        fatalError("No factory found for type: \(type)")
    }
}

