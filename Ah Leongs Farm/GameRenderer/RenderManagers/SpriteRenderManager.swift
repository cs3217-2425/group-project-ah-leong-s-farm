//
//  SpriteRenderManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 27/3/25.
//

import GameplayKit

class SpriteRenderManager: IRenderManager {
    private static let EntityTypeTextureMap: [ObjectIdentifier: String] = [
        ObjectIdentifier(Plot.self): "dirt"
    ]

    private weak var uiPositionProvider: UIPositionProvider?

    init(uiPositionProvider: UIPositionProvider) {
        self.uiPositionProvider = uiPositionProvider
    }

    func createNode(for entity: EntityType, in renderer: GameRenderer) {
        guard let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
            return
        }

        let visitor = spriteComponent.spriteRenderManagerVisitor
        visitor.visitSpriteRenderManager(manager: self, renderer: renderer)
    }

    func createNodeForEntity(plot: Plot, in renderer: GameRenderer) {
        guard let positionComponent = plot.component(ofType: PositionComponent.self) else {
            return
        }

        guard let textureName = getTextureName(for: Plot.self) else {
            return
        }

        let spriteNode = PlotSpriteNode(imageNamed: textureName)

        let position = uiPositionProvider?.getUIPosition(
            row: Int(positionComponent.x),
            column: Int(positionComponent.y)
        ) ?? .zero

        spriteNode.position = position

        renderer.setRenderNode(for: ObjectIdentifier(plot), node: spriteNode)
    }

    private func getTextureName(for entityType: EntityType.Type) -> String? {
        Self.EntityTypeTextureMap[ObjectIdentifier(entityType)]
    }

}
