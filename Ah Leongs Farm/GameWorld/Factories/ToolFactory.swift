//
//  ToolFactory.swift
//  Ah Leongs Farm
//
//  Created by proglab on 14/4/25.
//


class ToolFactory: EntityFactory {
    static private let initializers: [EntityType: () -> Entity] = [
        Fertiliser.type: { Fertiliser() },
        PremiumFertiliser.type: { PremiumFertiliser() }
    ]

    static func canCreate(type: EntityType) -> Bool {
        initializers[type] != nil
    }

    static func create(type: EntityType) -> Entity {
        guard let initFn = initializers[type] else {
            fatalError("No tool initializer for type: \(type)")
        }
        return initFn()
    }

    static func createMultiple(type: EntityType, quantity: Int) -> [Entity] {
        guard let initFn = initializers[type] else {
            fatalError("No tool initializer for type: \(type)")
        }
        return (0..<quantity).map { _ in initFn() }
    }
}
