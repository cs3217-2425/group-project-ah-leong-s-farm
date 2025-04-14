//
//  GameStateSerializer.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/4/25.
//

class GameStateSerializer {

    private let store: Store

    init(store: Store) {
        self.store = store
    }

    func serialize(gameState: GameState) -> GameStatePersistenceEntity? {
        guard let gameStatePersistenceEntity = fetchGameStatePersistenceEntity() else {
            return nil
        }

        updateAttributes(gameStatePersistenceEntity: gameStatePersistenceEntity, gameState: gameState)

        return gameStatePersistenceEntity
    }

    func serializeNew(gameState: GameState) -> GameStatePersistenceEntity {
        if let existingGameStatePersistenceEntity = fetchGameStatePersistenceEntity() {
            store.managedContext.delete(existingGameStatePersistenceEntity)
        }

        let newGameStatePersistenceEntity = GameStatePersistenceEntity(context: store.managedContext)
        updateAttributes(
            gameStatePersistenceEntity: newGameStatePersistenceEntity,
            gameState: gameState
        )

        return newGameStatePersistenceEntity
    }

    private func updateAttributes(gameStatePersistenceEntity: GameStatePersistenceEntity, gameState: GameState) {
        let energyComponent = gameState.getComponentByType(ofType: EnergyComponent.self)
        let turnComponent = gameState.getComponentByType(ofType: TurnComponent.self)
        let levelComponent = gameState.getComponentByType(ofType: LevelComponent.self)
        let walletComponent = gameState.getComponentByType(ofType: WalletComponent.self)

        gameStatePersistenceEntity.currentEnergy = Int64(energyComponent?.currentEnergy ?? 0)
        gameStatePersistenceEntity.maxEnergy = Int64(energyComponent?.maxEnergy ?? 0)

        gameStatePersistenceEntity.level = Int64(levelComponent?.level ?? 0)
        gameStatePersistenceEntity.currentXP = levelComponent?.currentXP ?? 0

        gameStatePersistenceEntity.currentTurn = Int64(turnComponent?.currentTurn ?? 0)
        gameStatePersistenceEntity.maxTurns = Int64(turnComponent?.maxTurns ?? 0)

        gameStatePersistenceEntity.walletCoinAmount = walletComponent?.getAmount(of: .coin) ?? 0
    }

    private func fetchGameStatePersistenceEntity() -> GameStatePersistenceEntity? {
        let request = GameStatePersistenceEntity.fetchRequest()
        return store.fetch(request: request).first
    }
}
