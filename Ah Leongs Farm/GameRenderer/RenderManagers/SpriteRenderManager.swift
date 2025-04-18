//
//  SpriteRenderManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 27/3/25.
//

import Foundation

class SpriteRenderManager: IRenderManager {
    private static let EntityTypeTextureMap: [EntityType: String] = [
        Plot.type: "dirt"
    ]

    private static let SeedTypeTextureMap: [EntityType: String] = [
        AppleSeed.type: "apple_seed",
        BokChoySeed.type: "bokchoy_seed",
        PotatoSeed.type: "potato_seed"
    ]

    private static let CropTypeTextureMap: [EntityType: String] = [
        Apple.type: "apple_harvested",
        BokChoy.type: "bokchoy_harvested",
        Potato.type: "potato_harvested"
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
        visitor.createNode(manager: self, renderer: renderer)
    }

    func transformNode(_ node: any IRenderNode, for entity: any Entity, in renderer: GameRenderer) {
        guard let spriteComponent = entity.getComponentByType(ofType: SpriteComponent.self) else {
            return
        }

        let visitor = spriteComponent.spriteRenderManagerVisitor
        visitor.transformNode(node, manager: self, renderer: renderer)
    }

    func createNodeForEntity(plot: Plot, in renderer: GameRenderer) {
        guard let positionComponent = plot.getComponentByType(ofType: PositionComponent.self) else {
            return
        }

        guard let textureName = Self.EntityTypeTextureMap[Plot.type] else {
            return
        }

        let spriteNode = PlotSpriteNode(imageNamed: textureName)

        setSpritePosition(spriteNode: spriteNode, using: positionComponent)

        setRelativeSize(spriteNode: spriteNode, scaleFactor: 1.0)
        renderer.setRenderNode(for: ObjectIdentifier(plot), node: spriteNode)
    }

    func transformNodeForEntity(_ node: any IRenderNode, plot: Plot, in renderer: GameRenderer) {
    }

    func createNodeForEntity(apple: Apple, in renderer: GameRenderer) {
        guard let textureName = Self.CropTypeTextureMap[Apple.type] else {
            return
        }

        createCropNode(for: apple, in: renderer, textureName: textureName)
    }

    func transformNodeForEntity(_ node: any IRenderNode, apple: Apple, in renderer: GameRenderer) {
    }

    func createNodeForEntity(appleSeed: AppleSeed, in renderer: GameRenderer) {
        guard let textureName = Self.SeedTypeTextureMap[AppleSeed.type] else {
            return
        }

        createSeedNode(for: appleSeed, in: renderer, textureName: textureName)
    }

    func transformNodeForEntity(_ node: any IRenderNode, appleSeed: AppleSeed, in renderer: GameRenderer) {
    }

    func createNodeForEntity(bokChoy: BokChoy, in renderer: GameRenderer) {
        guard let textureName = Self.CropTypeTextureMap[BokChoy.type] else {
            return
        }

        createCropNode(for: bokChoy, in: renderer, textureName: textureName)
    }

    func transformNodeForEntity(_ node: any IRenderNode, bokChoy: BokChoy, in renderer: GameRenderer) {
    }

    func createNodeForEntity(bokChoySeed: BokChoySeed, in renderer: GameRenderer) {
        guard let textureName = Self.SeedTypeTextureMap[BokChoySeed.type] else {
            return
        }

        createSeedNode(for: bokChoySeed, in: renderer, textureName: textureName)
    }

    func transformNodeForEntity(_ node: any IRenderNode, bokChoySeed: BokChoySeed, in renderer: GameRenderer) {
    }

    func createNodeForEntity(potato: Potato, in renderer: GameRenderer) {
        guard let textureName = Self.CropTypeTextureMap[Potato.type] else {
            return
        }

        createCropNode(for: potato, in: renderer, textureName: textureName)
    }

    func transformNodeForEntity(_ node: any IRenderNode, potato: Potato, in renderer: GameRenderer) {
    }

    func createNodeForEntity(potatoSeed: PotatoSeed, in renderer: GameRenderer) {
        guard let textureName = Self.SeedTypeTextureMap[PotatoSeed.type] else {
            return
        }

        createSeedNode(for: potatoSeed, in: renderer, textureName: textureName)
    }

    func transformNodeForEntity(_ node: any IRenderNode, potatoSeed: PotatoSeed, in renderer: GameRenderer) {
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

    private func createSeedNode(for seed: Seed, in renderer: GameRenderer, textureName: String) {
        guard let positionComponent = seed.getComponentByType(ofType: PositionComponent.self) else {
            return
        }

        let spriteNode = CropSpriteNode(imageNamed: textureName)

        setSpritePosition(spriteNode: spriteNode, using: positionComponent)
        setRelativeSize(spriteNode: spriteNode, scaleFactor: 1.0)
        renderer.setRenderNode(for: ObjectIdentifier(seed), node: spriteNode)
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
