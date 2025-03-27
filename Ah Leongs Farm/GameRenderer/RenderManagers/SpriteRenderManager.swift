//
//  SpriteRenderManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 27/3/25.
//

import SpriteKit

class SpriteRenderManager: IRenderManager {
    func createNode(of entity: EntityType) -> IRenderNode? {
        guard let spriteComponent = entity.component(ofType: SpriteComponent.self),
              let positionComponent = entity.component(ofType: PositionComponent.self) else {
            return nil
        }

        let spriteRenderNode = SpriteRenderNode(imageNamed: spriteComponent.textureName)
        let position = CGPoint(x: positionComponent.x, y: positionComponent.y)
        spriteRenderNode.skNode.position = position

        return spriteRenderNode
    }

    func updateNode(for node: inout IRenderNode, using entity: EntityType) {
        guard let spriteComponent = entity.component(ofType: SpriteComponent.self),
              let positionComponent = entity.component(ofType: PositionComponent.self) else {
            return
        }

        let position = CGPoint(x: positionComponent.x, y: positionComponent.y)
        node.skNode.position = position
    }
}

