//
//  SpriteRenderManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 27/3/25.
//

import GameplayKit

class SpriteRenderManager: IRenderManager {
    private(set) var entityNodeMap: [ObjectIdentifier: SpriteRenderNode] = [:]

    private weak var uiPositionProvider: UIPositionProvider?

    init(uiPositionProvider: UIPositionProvider) {
        self.uiPositionProvider = uiPositionProvider
    }

    func createNode(of entity: EntityType, in scene: SKScene) {
        if entityNodeMap[ObjectIdentifier(entity)] != nil {
            return
        }

        guard let spriteComponent = entity.component(ofType: SpriteComponent.self),
              let positionComponent = entity.component(ofType: PositionComponent.self) else {
            return
        }

        let spriteRenderNode = SpriteRenderNode(imageNamed: spriteComponent.textureName)
        let position = uiPositionProvider?.getUIPosition(
            row: Int(positionComponent.x),
            column: Int(positionComponent.y)
        ) ?? .zero

        spriteRenderNode.skNode.position = position

        scene.addChild(spriteRenderNode.skNode)
        entityNodeMap[ObjectIdentifier(entity)] = spriteRenderNode
    }

    func removeNode(of entityIdentifier: ObjectIdentifier, in scene: SKScene) {
        guard let node = entityNodeMap[entityIdentifier] else {
            return
        }

        node.skNode.removeFromParent()
        entityNodeMap.removeValue(forKey: entityIdentifier)
    }
}
