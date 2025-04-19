//
//  SpriteRenderManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 27/3/25.
//

import Foundation

class SpriteRenderManager: IRenderManager {
    private static let EntityTypeTextureMap: [EntityType: String] = [
        Plot.type: "dirt",
        SolarPanel.type: "solar_panel"
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
        visitor.visitSpriteRenderManager(manager: self, renderer: renderer)
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

    func createNodeForEntity(solarPanel: SolarPanel, in renderer: GameRenderer) {
        guard let textureName = Self.EntityTypeTextureMap[SolarPanel.type] else {
            return
        }

        guard let positionComponent = solarPanel.getComponentByType(ofType: PositionComponent.self) else {
            return
        }

        let spriteNode = SolarPanelSpriteNode(imageNamed: textureName)

        setSpritePosition(spriteNode: spriteNode, using: positionComponent)
        setRelativeSize(spriteNode: spriteNode, scaleFactor: 1.0)
        renderer.setRenderNode(for: ObjectIdentifier(solarPanel), node: spriteNode)
    }

    func createNodeForEntity(apple: Apple, in renderer: GameRenderer) {
        guard let textureName = Self.CropTypeTextureMap[Apple.type] else {
            return
        }

        createCropNode(for: apple, in: renderer, textureName: textureName)
    }

    func createNodeForEntity(appleSeed: AppleSeed, in renderer: GameRenderer) {
        guard let textureName = Self.SeedTypeTextureMap[AppleSeed.type] else {
            return
        }

        createSeedNode(for: appleSeed, in: renderer, textureName: textureName)
    }

    func createNodeForEntity(bokChoy: BokChoy, in renderer: GameRenderer) {
        guard let textureName = Self.CropTypeTextureMap[BokChoy.type] else {
            return
        }

        createCropNode(for: bokChoy, in: renderer, textureName: textureName)
    }

    func createNodeForEntity(bokChoySeed: BokChoySeed, in renderer: GameRenderer) {
        guard let textureName = Self.SeedTypeTextureMap[BokChoySeed.type] else {
            return
        }

        createSeedNode(for: bokChoySeed, in: renderer, textureName: textureName)
    }

    func createNodeForEntity(potato: Potato, in renderer: GameRenderer) {
        guard let textureName = Self.CropTypeTextureMap[Potato.type] else {
            return
        }

        createCropNode(for: potato, in: renderer, textureName: textureName)
    }

    func createNodeForEntity(potatoSeed: PotatoSeed, in renderer: GameRenderer) {
        guard let textureName = Self.SeedTypeTextureMap[PotatoSeed.type] else {
            return
        }

        createSeedNode(for: potatoSeed, in: renderer, textureName: textureName)
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
