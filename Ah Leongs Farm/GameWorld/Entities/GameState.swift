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

    init(maxTurns: Int) {
        super.init()
        setUpComponents(maxTurns: maxTurns)
    }

    private func setUpComponents(maxTurns: Int) {
        let turnComponent = TurnComponent(maxTurns: maxTurns)
        let energyBankComponent = EnergyBankComponent()
        let levelComponent = LevelComponent()
        let walletComponent = WalletComponent()
        let upgradeComponent = UpgradeComponent()
        attachComponent(turnComponent)
        attachComponent(energyBankComponent)
        attachComponent(levelComponent)
        attachComponent(walletComponent)
        attachComponent(upgradeComponent)
    }
}
