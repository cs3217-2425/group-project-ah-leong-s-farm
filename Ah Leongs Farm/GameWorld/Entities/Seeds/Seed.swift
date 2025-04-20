//
//  Seed.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 13/4/25.
//

import Foundation

protocol Seed: SpriteRenderManagerVisitor where Self: EntityAdapter {
    func toCrop() -> Crop
}

extension Seed {
    func createNode(manager: SpriteRenderManager, renderer: GameRenderer) {
        manager.createNodeForEntity(seed: self, in: renderer)
    }
}
