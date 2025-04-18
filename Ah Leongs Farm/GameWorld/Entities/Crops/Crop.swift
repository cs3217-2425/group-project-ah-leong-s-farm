//
//  Crop.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 27/3/25.
//

import Foundation

protocol Crop: SpriteRenderManagerVisitor,
               SpriteRenderManagerUpdateVisitor where Self: EntityAdapter {

}

extension Crop {
    func createNode(manager: SpriteRenderManager, renderer: GameRenderer) {
        manager.createNodeForEntity(crop: self, in: renderer)
    }

    func transformNode(_ node: any IRenderNode, manager: SpriteRenderManager, renderer: GameRenderer) {
        manager.transformNodeForEntity(node, crop: self, in: renderer)
    }
}
