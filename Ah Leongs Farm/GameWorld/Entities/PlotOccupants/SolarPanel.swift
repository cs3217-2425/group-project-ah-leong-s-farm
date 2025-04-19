//
//  SolarPanel.swift
//  Ah Leongs Farm
//
//  Created by proglab on 15/4/25.
//

import Foundation

class SolarPanel: EntityAdapter, PlotOccupant, Tool, GamePersistenceObject {
    override init() {
        super.init()
        setUpComponents()
    }

    init(config: SolarPanelConfig) {
        super.init()
        setUpComponents(config: config)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    private func setUpComponents() {
        let energyCapBoostComponent = EnergyCapBoostComponent()
        attachComponent(energyCapBoostComponent)

        let persistenceComponent = PersistenceComponent(persistenceObject: self)
        attachComponent(persistenceComponent)
    }

    private func setUpComponents(config: SolarPanelConfig) {
        let energyCapBoostComponent = EnergyCapBoostComponent()
        attachComponent(energyCapBoostComponent)

        let persistenceComponent = PersistenceComponent(
            persistenceObject: self,
            persistenceId: config.persistenceId
        )
        attachComponent(persistenceComponent)

        if config.isItem {
            let itemComponent = ItemComponent()
            attachComponent(itemComponent)
        }

        if let position = config.position {
            let positionComponent = PositionComponent(x: position.x, y: position.y)
            attachComponent(positionComponent)
        }
    }

    func save(manager: PersistenceManager, persistenceId: UUID) -> Bool {
        manager.save(solarPanel: self, persistenceId: persistenceId)
    }

    func delete(manager: PersistenceManager, persistenceId: UUID) -> Bool {
        manager.delete(solarPanel: self, persistenceId: persistenceId)
    }
}

extension SolarPanel: SpriteRenderManagerVisitor {
    func visitSpriteRenderManager(manager: SpriteRenderManager, renderer: GameRenderer) {
        manager.createNodeForEntity(solarPanel: self, in: renderer)
    }
}
