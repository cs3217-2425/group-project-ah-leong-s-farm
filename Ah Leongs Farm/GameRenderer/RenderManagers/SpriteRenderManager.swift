//
//  SpriteRenderManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 27/3/25.
//

import Foundation

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

    func createNode(for entity: Entity, in renderer: GameRenderer) {
        guard let spriteComponent = entity.getComponentByType(ofType: SpriteComponent.self) else {
            return
        }

        let visitor = spriteComponent.spriteRenderManagerVisitor
        visitor.visitSpriteRenderManager(manager: self, renderer: renderer)
    }

    func createNodeForEntity(plot: Plot, in renderer: GameRenderer) {
        guard let positionComponent = plot.getComponentByType(ofType: PositionComponent.self) else {
            return
        }

        guard let textureName = Self.EntityTypeTextureMap[ObjectIdentifier(Plot.self)] else {
            return
        }

        let spriteNode = PlotSpriteNode(imageNamed: textureName)

        setSpritePosition(spriteNode: spriteNode, using: positionComponent)

        setRelativeSize(spriteNode: spriteNode, scaleFactor: 1.0)
        renderer.setRenderNode(for: ObjectIdentifier(plot), node: spriteNode)
    }

    func createNodeForEntity(apple: Apple, in renderer: GameRenderer) {
        guard let textureName = Self.CropTypeSeedTextureMap[ObjectIdentifier(Apple.self)] else {
            return
        }

        createCropNode(for: apple, in: renderer, textureName: textureName)
    }

    func createNodeForEntity(bokChoy: BokChoy, in renderer: GameRenderer) {
        guard let textureName = Self.CropTypeSeedTextureMap[ObjectIdentifier(BokChoy.self)] else {
            return
        }

        createCropNode(for: bokChoy, in: renderer, textureName: textureName)
    }

    func createNodeForEntity(potato: Potato, in renderer: GameRenderer) {
        guard let textureName = Self.CropTypeSeedTextureMap[ObjectIdentifier(Potato.self)] else {
            return
        }

        createCropNode(for: potato, in: renderer, textureName: textureName)
    }

    private func createCropNode(for crop: Crop, in renderer: GameRenderer, textureName: String) {
        guard let positionComponent = crop.getComponentByType(ofType: PositionComponent.self) else {
            return
        }

        let spriteNode = CropSpriteNode(imageNamed: textureName)

        setSpritePosition(spriteNode: spriteNode, using: positionComponent)
        setRelativeSize(spriteNode: spriteNode, scaleFactor: 1.0)
        renderer.setRenderNode(for: ObjectIdentifier(crop), node: spriteNode)
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
