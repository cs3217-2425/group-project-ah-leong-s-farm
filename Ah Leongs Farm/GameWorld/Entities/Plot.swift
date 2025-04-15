//
//  PlotEntity.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/3/25.
//

import Foundation

class Plot: EntityAdapter {
    private static let DefaultSoilQuality: Float = 1.0

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init(position: CGPoint, crop: Crop? = nil) {
        super.init()
        setUpComponents(position: position, crop: crop)
    }

    func setUpComponents(position: CGPoint, crop: Crop? = nil) {
        attachComponent(CropSlotComponent(crop: crop))
        attachComponent(PositionComponent(x: position.x, y: position.y))
        attachComponent(SoilComponent(quality: Plot.DefaultSoilQuality, hasWater: false))
        attachComponent(SpriteComponent(visitor: self))
    }
}

extension Plot: SpriteRenderManagerVisitor {
    func visitSpriteRenderManager(manager: SpriteRenderManager, renderer: GameRenderer) {
        manager.createNodeForEntity(plot: self, in: renderer)
    }
}
