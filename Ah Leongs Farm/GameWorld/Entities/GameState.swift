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
    let maxBaseEnergy: Int
    let currentBaseEnergy: Int
    let level: Int
    let currentXP: Float
    let coinAmount: Double
}

class GameState: EntityAdapter {
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init(maxTurns: Int) {
        super.init()
        setUpComponents(maxTurns: maxTurns)
    }

    init(config: GameStateConfig) {
        super.init()
        setUpComponents(config: config)
    }

    private func setUpComponents(maxTurns: Int) {
        let turnComponent = TurnComponent(maxTurns: maxTurns)
        let energyBankComponent = EnergyBankComponent()
        let levelComponent = LevelComponent()
        let walletComponent = WalletComponent()
        let upgradeComponent = UpgradeComponent(points: 3)
        let persistenceComponent = PersistenceComponent(persistenceObject: self)

        attachComponent(turnComponent)
        attachComponent(energyBankComponent)
        attachComponent(levelComponent)
        attachComponent(walletComponent)
        attachComponent(upgradeComponent)
        attachComponent(persistenceComponent)
    }

    private func setUpComponents(config: GameStateConfig) {
        let energies: [EnergyType: EnergyStat] = [
            .base: EnergyStat(current: config.currentBaseEnergy, max: config.maxBaseEnergy)
        ]

        attachComponent(TurnComponent(maxTurns: config.maxTurns, currentTurn: config.currentTurn))
        attachComponent(EnergyBankComponent(initialEnergies: energies))
        attachComponent(LevelComponent(level: config.level, currentXP: config.currentXP))
        attachComponent(WalletComponent(coinAmount: config.coinAmount))
        attachComponent(PersistenceComponent(persistenceObject: self))
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
