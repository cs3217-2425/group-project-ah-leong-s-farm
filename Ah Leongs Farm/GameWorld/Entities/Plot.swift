//
//  PlotEntity.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/3/25.
//

import Foundation

class Plot: EntityAdapter {
    private static let DefaultSoilQuality: Float = 0
    private static let DefaultSoilMoisture: Float = 0

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
        attachComponent(SoilComponent(quality: Plot.DefaultSoilQuality, moisture: Plot.DefaultSoilMoisture))
        attachComponent(SpriteComponent(visitor: self))
        attachComponent(PersistenceComponent(visitor: self))
    }
}

extension Plot: PersistenceVisitor {
    func visitPersistenceManager(manager: PersistenceManager) {
        manager.save(plot: self)
    }
}

extension Plot: SpriteRenderManagerVisitor {
    func visitSpriteRenderManager(manager: SpriteRenderManager, renderer: GameRenderer) {
        manager.createNodeForEntity(plot: self, in: renderer)
    }
}
