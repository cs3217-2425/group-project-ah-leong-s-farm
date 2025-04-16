//
//  EntityFactoryRegistry.swift
//  Ah Leongs Farm
//
//  Created by proglab on 14/4/25.
//

class EntityFactoryRegistry: EntityFactory {

    private static let factories: [EntityFactory.Type] = [
        SeedFactory.self,
        CropFactory.self,
        ToolFactory.self
    ]

    static func canCreate(type: EntityType) -> Bool {
        factories.contains { $0.canCreate(type: type) }
    }

    static func create(type: EntityType) -> Entity {
        if let factory = factories.first(where: { $0.canCreate(type: type) }) {
            return factory.create(type: type)
        }
        fatalError("No factory found for type: \(type)")
    }

    static func createMultiple(type: EntityType, quantity: Int) -> [Entity] {
        if let factory = factories.first(where: { $0.canCreate(type: type) }) {
            return factory.createMultiple(type: type, quantity: quantity)
        }

        fatalError("No factory found for type: \(type)")
    }
}
