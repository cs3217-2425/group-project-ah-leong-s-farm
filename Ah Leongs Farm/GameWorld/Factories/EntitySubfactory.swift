//
//  EntitySubfactory.swift
//  Ah Leongs Farm
//
//  Created by proglab on 14/4/25.
//


protocol EntitySubfactory {
    func canCreate(type: EntityType) -> Bool
    func create(type: EntityType) -> Entity
    func createMultiple(type: EntityType, quantity: Int) -> [Entity]
}
