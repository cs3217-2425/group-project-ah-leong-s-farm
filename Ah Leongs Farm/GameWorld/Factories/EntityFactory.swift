//
//  Entityfactory.swift
//  Ah Leongs Farm
//
//  Created by proglab on 14/4/25.
//

protocol EntityFactory {
    static func canCreate(type: EntityType) -> Bool
    static func create(type: EntityType) -> Entity
    static func createMultiple(type: EntityType, quantity: Int) -> [Entity]
}
