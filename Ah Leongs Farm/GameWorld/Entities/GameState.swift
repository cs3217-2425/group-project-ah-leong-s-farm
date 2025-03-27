//
//  GameState.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 19/3/25.
//

import GameplayKit

class GameState: GKEntity {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpComponents(maxTurns: 30, maxEnergy: 10)
    }

    init(maxTurns: Int, maxEnergy: Int) {
        super.init()
        setUpComponents(maxTurns: maxTurns, maxEnergy: maxEnergy)
    }

    private func setUpComponents(maxTurns: Int, maxEnergy: Int) {
        let turnComponent = TurnComponent(maxTurns: maxTurns)
        let energyComponent = EnergyComponent(maxEnergy: maxEnergy)
        let levelComponent = LevelComponent()
        let walletComponent = WalletComponent()
        addComponent(turnComponent)
        addComponent(energyComponent)
        addComponent(levelComponent)
        addComponent(walletComponent)
    }
}
