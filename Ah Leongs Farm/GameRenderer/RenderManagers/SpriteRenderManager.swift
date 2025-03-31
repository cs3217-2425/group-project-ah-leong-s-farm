//
//  SpriteRenderManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 27/3/25.
//

import GameplayKit

class SpriteRenderManager: IRenderManager {
    private static let PlotTextureName: String = "dirt"

    private weak var uiPositionProvider: UIPositionProvider?

    init(uiPositionProvider: UIPositionProvider) {
        self.uiPositionProvider = uiPositionProvider
    }

    func accept(visitor: SpriteRenderManagerVisitor, renderer: GameRenderer) {
        visitor.visitSpriteRenderManager(manager: self, renderer: renderer)
    }

    func createNode(for entity: EntityType, in renderer: GameRenderer) {
        guard let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
            return
        }

        accept(visitor: spriteComponent.spriteRenderManagerVisitor, renderer: renderer)
    }

    func createNode(plot: Plot, in renderer: GameRenderer) {
        guard let positionComponent = plot.component(ofType: PositionComponent.self) else {
            return
        }

        let spriteNode = PlotSpriteNode(imageNamed: Self.PlotTextureName)

        let position = uiPositionProvider?.getUIPosition(
            row: Int(positionComponent.x),
            column: Int(positionComponent.y)
        ) ?? .zero

        spriteNode.position = position

        renderer.setRenderNode(for: ObjectIdentifier(plot), node: spriteNode)
    }
}
