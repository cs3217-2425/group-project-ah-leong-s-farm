//
//  Crop.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 27/3/25.
//

protocol Crop where Self: EntityAdapter {
    static func createSeed() -> Entity
    static func createHarvested() -> Entity
}
