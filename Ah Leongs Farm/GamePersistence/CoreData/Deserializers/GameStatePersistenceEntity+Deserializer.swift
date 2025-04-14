//
//  GameStatePersistenceEntity+Deserializer.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/4/25.
//

extension GameStatePersistenceEntity {
    func deserialize() -> GameState {
        let config = GameStateConfig(
            maxTurns: Int(maxTurns),
            currentTurn: Int(currentTurn),
            maxEnergy: Int(maxEnergy),
            currentEnergy: Int(currentEnergy),
            level: Int(level),
            currentXP: currentXP,
            coinAmount: walletCoinAmount
        )
        return GameState(config: config)
    }
}
