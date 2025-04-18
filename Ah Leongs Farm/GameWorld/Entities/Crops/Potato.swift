//
//  Potato.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 30/3/25.
//

import Foundation

class Potato: EntityAdapter, Crop {
    override init() {
        super.init()
        setUpComponents()
    }

    init(config: CropConfig) {
        super.init()
        setUpComponents(config: config)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    private func setUpComponents() {
        let cropComponent = CropComponent(cropType: .potato)
        attachComponent(cropComponent)

        let healthComponent = HealthComponent()
        attachComponent(healthComponent)

        let persistenceComponent = PersistenceComponent(persistenceObject: self)
        attachComponent(persistenceComponent)
    }

    private func setUpComponents(config: CropConfig) {
        let cropComponent = CropComponent(cropType: .apple)
        attachComponent(cropComponent)

        let healthComponent = HealthComponent(health: config.health)
        attachComponent(healthComponent)

        let persistenceComponent = PersistenceComponent(
            persistenceObject: self,
            persistenceId: config.persistenceID
        )
        attachComponent(persistenceComponent)

        if let position = config.position {
            let positionComponent = PositionComponent(x: position.x, y: position.y)
            attachComponent(positionComponent)
        }

        if let growthConfig = config.growthConfig {
            let growthComponent = GrowthComponent(
                totalGrowthTurns: growthConfig.totalGrowthTurns,
                currentGrowthTurn: growthConfig.currentGrowthTurn
            )

            attachComponent(growthComponent)
        }

        if config.isHarvested {
            let harvestedComponent = HarvestedComponent()
            attachComponent(harvestedComponent)
        }

        if config.isItem {
            let itemComponent = ItemComponent()
            attachComponent(itemComponent)
        }
    }

    func visitSpriteRenderManager(manager: SpriteRenderManager, renderer: GameRenderer) {
        manager.createNodeForEntity(potato: self, in: renderer)
    }

    func save(manager: PersistenceManager, persistenceId: UUID) -> Bool {
        manager.save(potato: self, persistenceId: persistenceId)
    }

    func delete(manager: PersistenceManager, persistenceId: UUID) -> Bool {
        manager.delete(potato: self, persistenceId: persistenceId)
    }
}
