//
//  GameState.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 19/3/25.
//

import Foundation

struct GameStateConfig {
    let maxTurns: Int
    let currentTurn: Int
    let maxEnergy: Int
    let currentEnergy: Int
    let level: Int
    let currentXP: Float
    let coinAmount: Double
}

class GameState: EntityAdapter {
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init(maxTurns: Int, maxEnergy: Int) {
        super.init()
        setUpComponents(maxTurns: maxTurns, maxEnergy: maxEnergy)
    }

    init(config: GameStateConfig) {
        super.init()
        setUpComponents(config: config)
    }

    private func setUpComponents(maxTurns: Int, maxEnergy: Int) {
        let turnComponent = TurnComponent(maxTurns: maxTurns)
        let energyComponent = EnergyComponent(maxEnergy: maxEnergy)
        let levelComponent = LevelComponent()
        let walletComponent = WalletComponent()
        let persistenceComponent = PersistenceComponent(persistenceObject: self)

        attachComponent(turnComponent)
        attachComponent(energyComponent)
        attachComponent(levelComponent)
        attachComponent(walletComponent)
        attachComponent(persistenceComponent)
    }

    private func setUpComponents(config: GameStateConfig) {
        attachComponent(TurnComponent(maxTurns: config.maxTurns, currentTurn: config.currentTurn))
        attachComponent(EnergyComponent(currentEnergy: config.currentEnergy, maxEnergy: config.maxEnergy))
        attachComponent(LevelComponent(level: config.level, currentXP: config.currentXP))
        attachComponent(WalletComponent(coinAmount: config.coinAmount))
        addComponent(PersistenceComponent(persistenceObject: self))
    }
}

extension GameState: GamePersistenceObject {
    func save(manager: PersistenceManager, persistenceId: UUID) -> Bool {
        manager.save(gameState: self)
    }

    func delete(manager: PersistenceManager, persistenceId: UUID) -> Bool {
        manager.delete(gameState: self)
    }
}
