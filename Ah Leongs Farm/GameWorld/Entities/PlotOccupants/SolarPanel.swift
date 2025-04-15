//
//  SolarPanel.swift
//  Ah Leongs Farm
//
//  Created by proglab on 15/4/25.
//

import Foundation

class SolarPanel: EntityAdapter {
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

    func visitSpriteRenderManager(manager: SpriteRenderManager, renderer: GameRenderer) {
        // TO ADD LATER
    }
}
