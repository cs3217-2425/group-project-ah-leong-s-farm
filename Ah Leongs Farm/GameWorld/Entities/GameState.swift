//
//  GameState.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 19/3/25.
//

import Foundation

class GameState: EntityAdapter {
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init(maxTurns: Int, maxEnergy: Int) {
        super.init()
        setUpComponents(maxTurns: maxTurns, maxEnergy: maxEnergy)
    }

    init(maxTurns: Int, currentTurn: Int, maxEnergy: Int, currentEnergy: Int, level: Int,
         currentXP: Float, coinAmount: Double) {
        super.init()
        setUpComponents(maxTurns: maxTurns, currentTurn: currentTurn, maxEnergy: maxEnergy,
                        currentEnergy: currentEnergy, level: level, currentXP: currentXP,
                        coinAmount: coinAmount)
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

    private func setUpComponents(maxTurns: Int, currentTurn: Int, maxEnergy: Int,
                                 currentEnergy: Int, level: Int, currentXP: Float,
                                 coinAmount: Double) {
        let turnComponent = TurnComponent(maxTurns: maxTurns, currentTurn: currentTurn)
        let energyComponent = EnergyComponent(currentEnergy: currentEnergy, maxEnergy: maxEnergy)
        let levelComponent = LevelComponent(level: level, currentXP: currentXP)
        let walletComponent = WalletComponent(coinAmount: coinAmount)
        let persistenceComponent = PersistenceComponent(persistenceObject: self)

        attachComponent(turnComponent)
        attachComponent(energyComponent)
        attachComponent(levelComponent)
        attachComponent(walletComponent)
        addComponent(persistenceComponent)
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
