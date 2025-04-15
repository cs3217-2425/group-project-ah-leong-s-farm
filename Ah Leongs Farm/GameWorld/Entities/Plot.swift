//
//  PlotEntity.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/3/25.
//

import Foundation

class Plot: EntityAdapter {
    private static let DefaultSoilQuality: Float = 0

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init(position: CGPoint, plotOccupant: PlotOccupant? = nil) {
        super.init()
        setUpComponents(position: position, plotOccupant: plotOccupant)
    }

    func setUpComponents(position: CGPoint, plotOccupant: PlotOccupant? = nil) {
        attachComponent(PlotOccupantSlotComponent(plotOccupant: plotOccupant))
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
