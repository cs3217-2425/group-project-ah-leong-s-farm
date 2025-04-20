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

    private static let CropTypeTextureMap: [EntityType: [String]] = [
        Apple.type: ["apple_seed",
                     "apple_stage_1",
                     "apple_stage_2",
                     "apple_stage_3"],
        BokChoy.type: ["bokchoy_seed",
                       "bokchoy_stage_1",
                       "bokchoy_stage_2"],
        Potato.type: ["potato_seed",
                      "potato_stage_1"]
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

    func transformNode(_ node: IRenderNode, for entity: Entity, in renderer: GameRenderer) {
        guard let spriteComponent = entity.getComponentByType(ofType: SpriteComponent.self),
              let visitor = spriteComponent.spriteRenderManagerUpdateVisitor else {
            return
        }
        visitor.transformNode(node, manager: self, renderer: renderer)
    }

    func transformNodeForEntity(_ node: IRenderNode, crop: Crop, in renderer: GameRenderer) {
        guard let textureName = getTextureFromEntity(crop: crop) else {
            return
        }
        node.updateTexture(image: textureName)
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
        renderer.setRenderNode(for: plot.id, node: spriteNode)
    }

    func createNodeForEntity(crop: Crop, in renderer: GameRenderer) {
        guard let textureName = getTextureFromEntity(crop: crop),
              let cropNode = createCropNode(for: crop, textureName: textureName) else {

            return
        }
        renderer.setRenderNode(for: crop.id, node: cropNode)
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
        renderer.setRenderNode(for: solarPanel.id, node: spriteNode)
    }

    func createNodeForEntity(seed: Seed, in renderer: GameRenderer) {
        guard let textureName = getTextureFromEntity(seed: seed),
              let seedNode = createSeedNode(for: seed, textureName: textureName) else {
            return
        }
        renderer.setRenderNode(for: seed.id, node: seedNode)
    }

    private func getTextureFromEntity(crop: Crop) -> String? {
        guard let growthComponent = crop.getComponentByType(ofType: GrowthComponent.self),
              let textureMap = Self.CropTypeTextureMap[crop.type] else {
            return nil
        }
        let growthStage = growthComponent.currentGrowthStage
        guard growthStage < textureMap.count else {
            return nil
        }
        return textureMap[growthStage]
    }

    private func getTextureFromEntity(seed: Seed) -> String? {
        guard let textureName = Self.SeedTypeTextureMap[seed.type] else {
            return nil
        }
        return textureName
    }

    private func createCropNode(for crop: Crop, textureName: String) -> CropSpriteNode? {
        guard let positionComponent = crop.getComponentByType(ofType: PositionComponent.self) else {
            return nil
        }

        let spriteNode = CropSpriteNode(imageNamed: textureName)

        setSpritePosition(spriteNode: spriteNode, using: positionComponent)
        setRelativeSize(spriteNode: spriteNode, scaleFactor: 1.0)
        return spriteNode
    }

    private func createSeedNode(for seed: Seed, textureName: String) -> CropSpriteNode? {
        guard let positionComponent = seed.getComponentByType(ofType: PositionComponent.self) else {
            return nil
        }

        let spriteNode = CropSpriteNode(imageNamed: textureName)

        setSpritePosition(spriteNode: spriteNode, using: positionComponent)
        setRelativeSize(spriteNode: spriteNode, scaleFactor: 1.0)
        return spriteNode
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
