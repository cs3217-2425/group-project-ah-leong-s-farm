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

    init(position: CGPoint,
         soilQuality: Float,
         soilHasWater: Bool,
         persistenceID: UUID,
         plotOccupant: PlotOccupant? = nil) {
        super.init()
        setUpComponents(
            position: position,
            soilQuality: soilQuality,
            soilHasWater: soilHasWater,
            persistenceID: persistenceID,
            plotOccupant: plotOccupant
        )
    }

    convenience init(position: CGPoint, plotOccupant: PlotOccupant? = nil) {
        self.init(
            position: position,
            soilQuality: Plot.DefaultSoilQuality,
            soilHasWater: false,
            persistenceID: UUID(),
            plotOccupant: plotOccupant
        )
    }

    private func setUpComponents(
        position: CGPoint,
        soilQuality: Float,
        soilHasWater: Bool,
        persistenceID: UUID,
        plotOccupant: PlotOccupant? = nil
    ) {
        attachComponent(PlotOccupantSlotComponent(plotOccupant: plotOccupant))
        attachComponent(PositionComponent(x: position.x, y: position.y))
        attachComponent(SoilComponent(quality: soilQuality, hasWater: soilHasWater))
        attachComponent(SpriteComponent(visitor: self))
        attachComponent(RenderComponent(updatable: false))
        attachComponent(PersistenceComponent(persistenceObject: self, persistenceId: persistenceID))
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
    func createNode(manager: SpriteRenderManager, renderer: GameRenderer) {
        manager.createNodeForEntity(plot: self, in: renderer)
    }
}
