//
//  PlotSpriteRenderManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 29/3/25.
//

class PlotSpriteRenderManager: IRenderManager {
    private weak var uiPositionProvider: UIPositionProvider?

    init(uiPositionProvider: UIPositionProvider) {
        self.uiPositionProvider = uiPositionProvider
    }

    func createNode(of entity: EntityType) -> PlotSpriteRenderNode? {
        guard let spriteComponent = entity.component(ofType: SpriteComponent.self),
              let positionComponent = entity.component(ofType: PositionComponent.self),
              entity.component(ofType: SoilComponent.self) != nil else {
            return nil
        }

        let spriteRenderNode = PlotSpriteRenderNode(imageNamed: spriteComponent.textureName)

        let position = uiPositionProvider?.getUIPosition(
            row: Int(positionComponent.x),
            column: Int(positionComponent.y)
        ) ?? .zero

        spriteRenderNode.skNode.position = position

        return spriteRenderNode
    }
}
