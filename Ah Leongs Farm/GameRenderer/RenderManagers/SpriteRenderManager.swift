//
//  SpriteRenderManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 27/3/25.
//

import GameplayKit

class SpriteRenderManager: IRenderManager {
    private weak var uiPositionProvider: UIPositionProvider?

    private let spriteNodeFactories: [any SpriteNodeFactory] = [PlotSpriteNodeFactory()]

    init(uiPositionProvider: UIPositionProvider) {
        self.uiPositionProvider = uiPositionProvider
    }

    func createNode(of entity: EntityType) -> SpriteNode? {
        guard let spriteComponent = entity.component(ofType: SpriteComponent.self),
              let positionComponent = entity.component(ofType: PositionComponent.self) else {
            return nil
        }

        let spriteNode = spriteNodeFactories.compactMap { factory in
            factory.createNode(for: entity, textureName: spriteComponent.textureName)
        }.first ?? SpriteNode(imageNamed: spriteComponent.textureName)

        let position = uiPositionProvider?.getUIPosition(
            row: Int(positionComponent.x),
            column: Int(positionComponent.y)
        ) ?? .zero

        spriteNode.position = position

        return spriteNode
    }
}
