//
//  SolarPanel.swift
//  Ah Leongs Farm
//
//  Created by proglab on 15/4/25.
//

import Foundation

class SolarPanel: EntityAdapter, PlotOccupant, Tool {
    override init() {
        super.init()
        setUpComponents()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    private func setUpComponents() {
        let energyCapBoostComponent = EnergyCapBoostComponent()
        attachComponent(energyCapBoostComponent)
    }
}

extension SolarPanel: SpriteRenderManagerVisitor {
    func visitSpriteRenderManager(manager: SpriteRenderManager, renderer: GameRenderer) {
        manager.createNodeForEntity(solarPanel: self, in: renderer)
    }
}
