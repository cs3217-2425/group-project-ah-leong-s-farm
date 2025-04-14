//
//  CropFactory.swift
//  Ah Leongs Farm
//
//  Created by proglab on 14/4/25.
//


class CropFactory: EntitySubfactory {
    private let initializers: [EntityType: () -> Entity] = [
        Apple.type: { Apple() },
        BokChoy.type: { BokChoy() },
        Potato.type: { Potato() }
    ]

    func canCreate(type: EntityType) -> Bool {
        initializers[type] != nil
    }

    func create(type: EntityType) -> Entity {
        guard let initFn = initializers[type] else {
            fatalError("No crop initializer for type: \(type)")
        }
        return initFn()
    }

    func createMultiple(type: EntityType, quantity: Int) -> [Entity] {
        guard let initFn = initializers[type] else {
            fatalError("No crop initializer for type: \(type)")
        }
        return (0..<quantity).map { _ in initFn() }
    }
}
