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

    private func setUpComponents(maxTurns: Int, maxEnergy: Int) {
        let turnComponent = TurnComponent(maxTurns: maxTurns)
        let energyComponent = EnergyComponent(maxEnergy: maxEnergy)
        let levelComponent = LevelComponent()
        let walletComponent = WalletComponent()
        attachComponent(turnComponent)
        attachComponent(energyComponent)
        attachComponent(levelComponent)
        attachComponent(walletComponent)
    }
}
