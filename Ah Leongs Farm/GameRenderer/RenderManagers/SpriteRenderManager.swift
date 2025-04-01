//
//  SpriteRenderManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 27/3/25.
//

<<<<<<< Updated upstream
import GameplayKit

class SpriteRenderManager: IRenderManager {
    private weak var uiPositionProvider: UIPositionProvider?

    private let spriteNodeFactories: [any SpriteNodeFactory] = [PlotSpriteNodeFactory()]

    init(uiPositionProvider: UIPositionProvider) {
        self.uiPositionProvider = uiPositionProvider
    }

    func createNode(for entity: EntityType, in renderer: GameRenderer) {
=======
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
>>>>>>> Stashed changes
        guard let spriteComponent = entity.component(ofType: SpriteComponent.self),
              let positionComponent = entity.component(ofType: PositionComponent.self) else {
            return
        }

<<<<<<< Updated upstream
        let spriteNode = spriteNodeFactories.compactMap { factory in
            factory.createNode(for: entity, textureName: spriteComponent.textureName)
        }.first ?? SpriteNode(imageNamed: spriteComponent.textureName)

        let position = uiPositionProvider?.getUIPosition(
            row: Int(positionComponent.x),
            column: Int(positionComponent.y)
        ) ?? .zero

        spriteNode.position = position

        renderer.setRenderNode(for: ObjectIdentifier(entity), node: spriteNode)
    }
}
=======
        let position = CGPoint(x: positionComponent.x, y: positionComponent.y)
        node.skNode.position = position
    }
}

>>>>>>> Stashed changes
