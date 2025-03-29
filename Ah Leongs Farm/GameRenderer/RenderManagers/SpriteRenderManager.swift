//
//  SpriteRenderManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 27/3/25.
//

import GameplayKit

class GenericSpriteRenderManager: IRenderManager {
    private weak var uiPositionProvider: UIPositionProvider?

    init(uiPositionProvider: UIPositionProvider) {
        self.uiPositionProvider = uiPositionProvider
    }

    func createNode(of entity: EntityType) -> GenericSpriteRenderNode? {
        guard let spriteComponent = entity.component(ofType: SpriteComponent.self),
              let positionComponent = entity.component(ofType: PositionComponent.self) else {
            return nil
        }

        let skSpriteNode = SKSpriteNode(imageNamed: spriteComponent.textureName)

        let spriteRenderNode = GenericSpriteRenderNode(spriteNode: skSpriteNode)

        let position = uiPositionProvider?.getUIPosition(
            row: Int(positionComponent.x),
            column: Int(positionComponent.y)
        ) ?? .zero

        spriteRenderNode.skNode.position = position

        return spriteRenderNode
    }
}
