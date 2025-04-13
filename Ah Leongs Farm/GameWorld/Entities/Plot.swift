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

    init(position: CGPoint, soilQuality: Float, soilMoisture: Float, persistenceID: UUID,
         crop: Crop? = nil) {
        super.init()
        setUpComponents(
            position: position,
            soilQuality: soilQuality,
            soilMoisture: soilMoisture,
            persistenceID: persistenceID,
            crop: crop
        )
    }

    convenience init(position: CGPoint, crop: Crop? = nil) {
        self.init(
            position: position,
            soilQuality: Plot.DefaultSoilQuality,
            soilMoisture: Plot.DefaultSoilMoisture,
            persistenceID: UUID(),
            crop: crop
        )
    }

    private func setUpComponents(
        position: CGPoint,
        soilQuality: Float,
        soilMoisture: Float,
        persistenceID: UUID,
        crop: Crop? = nil
    ) {
        attachComponent(CropSlotComponent(crop: crop))
        attachComponent(PositionComponent(x: position.x, y: position.y))
        attachComponent(SoilComponent(quality: soilQuality, moisture: soilMoisture))
        attachComponent(SpriteComponent(visitor: self))
        attachComponent(PersistenceComponent(persistenceId: persistenceID, visitor: self))
    }
}

extension Plot: GamePersistenceObject {
    func save(manager: PersistenceManager, persistenceId: UUID) -> Bool {
        manager.save(plot: self, persistenceId: persistenceId)
    }

    func delete(manager: PersistenceManager, persistenceId persistenceID: UUID) -> Bool {
        manager.delete(plot: self, persistenceId: persistenceID)
    }
}

extension Plot: SpriteRenderManagerVisitor {
    func visitSpriteRenderManager(manager: SpriteRenderManager, renderer: GameRenderer) {
        manager.createNodeForEntity(plot: self, in: renderer)
    }
}
