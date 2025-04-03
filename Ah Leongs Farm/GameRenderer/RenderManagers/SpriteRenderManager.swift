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

    private static let CropTypeSeedTextureMap: [ObjectIdentifier: String] = [
        ObjectIdentifier(Apple.self): "apple_seed",
        ObjectIdentifier(BokChoy.self): "bokchoy_seed",
        ObjectIdentifier(Potato.self): "potato_seed"
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

        guard let textureName = Self.EntityTypeTextureMap[ObjectIdentifier(Plot.self)] else {
            return
        }

        let spriteNode = PlotSpriteNode(imageNamed: textureName)

        setSpritePosition(spriteNode: spriteNode, using: positionComponent)

        spriteNode.setPlot(plot)
        setRelativeSize(spriteNode: spriteNode, scaleFactor: 1.0)
        renderer.setRenderNode(for: ObjectIdentifier(plot), node: spriteNode)
    }

    func createNodeForEntity(apple: Apple, in renderer: GameRenderer) {
        guard let positionComponent = apple.component(ofType: PositionComponent.self) else {
            return
        }

        guard let textureName = Self.CropTypeSeedTextureMap[ObjectIdentifier(Apple.self)] else {
            return
        }

        let spriteNode = AppleSpriteNode(imageNamed: textureName)

        setSpritePosition(spriteNode: spriteNode, using: positionComponent)
        setRelativeSize(spriteNode: spriteNode, scaleFactor: 0.5)
        renderer.setRenderNode(for: ObjectIdentifier(apple), node: spriteNode)
    }

    func createNodeForEntity(bokChoy: BokChoy, in renderer: GameRenderer) {
        guard let positionComponent = bokChoy.component(ofType: PositionComponent.self) else {
            return
        }

        guard let textureName = Self.CropTypeSeedTextureMap[ObjectIdentifier(BokChoy.self)] else {
            return
        }

        let spriteNode = BokChoySpriteNode(imageNamed: textureName)

        setSpritePosition(spriteNode: spriteNode, using: positionComponent)
        setRelativeSize(spriteNode: spriteNode, scaleFactor: 0.5)
        renderer.setRenderNode(for: ObjectIdentifier(bokChoy), node: spriteNode)
    }

    func createNodeForEntity(potato: Potato, in renderer: GameRenderer) {
        guard let positionComponent = potato.component(ofType: PositionComponent.self) else {
            return
        }

        guard let textureName = Self.CropTypeSeedTextureMap[ObjectIdentifier(Potato.self)] else {
            return
        }

        let spriteNode = PotatoSpriteNode(imageNamed: textureName)

        setSpritePosition(spriteNode: spriteNode, using: positionComponent)
        setRelativeSize(spriteNode: spriteNode, scaleFactor: 0.5)
        renderer.setRenderNode(for: ObjectIdentifier(potato), node: spriteNode)
    }

    private func setSpritePosition(spriteNode: SpriteNode, using component: PositionComponent) {
        let position = uiPositionProvider?.getUIPosition(
            row: Int(component.x),
            column: Int(component.y)
        ) ?? .zero

        spriteNode.position = position
    }

    private func setRelativeSize(spriteNode: SpriteNode, scaleFactor: CGFloat) {
        assert(scaleFactor > 0, "Scale factor must be positive")

        let tileSize = TileMapRenderManager.TileSize
        spriteNode.size = CGSize(
            width: scaleFactor * tileSize.width,
            height: scaleFactor * tileSize.height
        )
    }

}
