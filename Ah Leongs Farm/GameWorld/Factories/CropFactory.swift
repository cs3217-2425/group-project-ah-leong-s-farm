//
//  CropFactory.swift
//  Ah Leongs Farm
//
//  Created by proglab on 14/4/25.
//

class CropFactory: EntityFactory {
    private static let initializers: [EntityType: () -> Entity] = [
        Apple.type: { Apple() },
        BokChoy.type: { BokChoy() },
        Potato.type: { Potato() }
    ]

    static func canCreate(type: EntityType) -> Bool {
        initializers[type] != nil
    }

    static func create(type: EntityType) -> Entity {
        guard let initFn = initializers[type] else {
            fatalError("No crop initializer for type: \(type)")
        }
        return initFn()
    }

    static func createMultiple(type: EntityType, quantity: Int) -> [Entity] {
        guard let initFn = initializers[type] else {
            fatalError("No crop initializer for type: \(type)")
        }
        return (0..<quantity).map { _ in initFn() }
    }
}
