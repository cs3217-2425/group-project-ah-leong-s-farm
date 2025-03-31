//
//  PlotEntity.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/3/25.
//

import GameplayKit

class Plot: GKEntity {
    private static let DefaultSoilQuality: Float = 0
    private static let DefaultSoilMoisture: Float = 0
    private static let SpriteTextureName = "dirt"

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(position: CGPoint, crop: Crop? = nil) {
        super.init()
        setUpComponents(position: position, crop: crop)
    }

    func setUpComponents(position: CGPoint, crop: Crop? = nil) {
        addComponent(CropSlotComponent(crop: crop))
        addComponent(PositionComponent(x: position.x, y: position.y))
        addComponent(SoilComponent(quality: Plot.DefaultSoilQuality, moisture: Plot.DefaultSoilMoisture))
        addComponent(SpriteComponent(visitor: self))
    }
}

extension Plot: SpriteRenderManagerVisitor {
    func visitSpriteRenderManager(manager: SpriteRenderManager, renderer: GameRenderer) {
        manager.createNode(plot: self, in: renderer)
    }
}

