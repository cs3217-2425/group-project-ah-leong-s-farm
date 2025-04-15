//
//  GameStatePersistenceEntity+Deserializer.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/4/25.
//

extension GameStatePersistenceEntity {
    func deserialize() -> GameState {
        let config = GameStateConfig(
            maxTurns: Int(turnComponent?.maxTurns ?? 0),
            currentTurn: Int(turnComponent?.currentTurn ?? 0),
            maxBaseEnergy: Int(energyComponent?.maxBaseEnergy ?? 0),
            currentBaseEnergy: Int(energyComponent?.currentBaseEnergy ?? 0),
            level: Int(levelComponent?.level ?? 0),
            currentXP: levelComponent?.currentXP ?? 0,
            coinAmount: walletComponent?.coinAmount ?? 0
        )
        return GameState(config: config)
    }
}
