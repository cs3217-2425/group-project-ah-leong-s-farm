//
//  GameStateSerializer.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/4/25.
//

import Foundation

class GameStateSerializer {

    private let store: Store

    init(store: Store) {
        self.store = store
    }

    func serialize(sessionId: UUID, gameState: GameState) -> GameStatePersistenceEntity? {
        guard let gameStatePersistenceEntity = fetchGameStatePersistenceEntity(sessionId: sessionId) else {
            return nil
        }

        updateAttributes(persistenceEntity: gameStatePersistenceEntity, gameState: gameState)

        return gameStatePersistenceEntity
    }

    func serializeNew(sessionId: UUID, gameState: GameState) -> GameStatePersistenceEntity? {
        guard let session = fetchSession(sessionId: sessionId) else {
            return nil
        }

        if let existingGameStatePersistenceEntity = session.gameState {
            store.managedContext.delete(existingGameStatePersistenceEntity)
        }

        let newGameStatePersistenceEntity = GameStatePersistenceEntity(context: store.managedContext)
        session.gameState = newGameStatePersistenceEntity

        updateAttributes(
            persistenceEntity: newGameStatePersistenceEntity,
            gameState: gameState
        )

        return newGameStatePersistenceEntity
    }

    private func updateAttributes(persistenceEntity: GameStatePersistenceEntity, gameState: GameState) {
        let energyComponent = gameState.getComponentByType(ofType: EnergyBankComponent.self)
        let turnComponent = gameState.getComponentByType(ofType: TurnComponent.self)
        let levelComponent = gameState.getComponentByType(ofType: LevelComponent.self)
        let walletComponent = gameState.getComponentByType(ofType: WalletComponent.self)
        let upgradeComponent = gameState.getComponentByType(ofType: UpgradeComponent.self)

        if let energyPersistenceComponent = persistenceEntity.energyComponent {
            energyPersistenceComponent.currentBaseEnergy = Int64(energyComponent?.getCurrentEnergy(
                of: .base) ?? 0)
            energyPersistenceComponent.maxBaseEnergy = Int64(energyComponent?.getMaxEnergy(
                of: .base) ?? 0)
        } else {
            let newComponent = EnergyPersistenceComponent(context: store.managedContext)
            newComponent.currentBaseEnergy = Int64(energyComponent?.getCurrentEnergy(
                of: .base) ?? 0)
            newComponent.maxBaseEnergy = Int64(energyComponent?.getMaxEnergy(
                of: .base) ?? 0)
            persistenceEntity.energyComponent = newComponent
        }

        if let levelPersistenceComponent = persistenceEntity.levelComponent {
            levelPersistenceComponent.level = Int64(levelComponent?.level ?? 0)
            levelPersistenceComponent.currentXP = levelComponent?.currentXP ?? 0
        } else {
            let newComponent = LevelPersistenceComponent(context: store.managedContext)
            newComponent.level = Int64(levelComponent?.level ?? 0)
            newComponent.currentXP = levelComponent?.currentXP ?? 0
            persistenceEntity.levelComponent = newComponent
        }

        if let turnPersistenceComponent = persistenceEntity.turnComponent {
            turnPersistenceComponent.currentTurn = Int64(turnComponent?.currentTurn ?? 0)
            turnPersistenceComponent.maxTurns = Int64(turnComponent?.maxTurns ?? 0)
        } else {
            let newComponent = TurnPersistenceComponent(context: store.managedContext)
            newComponent.currentTurn = Int64(turnComponent?.currentTurn ?? 0)
            newComponent.maxTurns = Int64(turnComponent?.maxTurns ?? 0)
            persistenceEntity.turnComponent = newComponent
        }

        if let walletPersistenceComponent = persistenceEntity.walletComponent {
            walletPersistenceComponent.coinAmount = Double(walletComponent?.getAmount(
                of: .coin) ?? 0)
        } else {
            let newComponent = WalletPersistenceComponent(context: store.managedContext)
            newComponent.coinAmount = Double(walletComponent?.getAmount(
                of: .coin) ?? 0)
            persistenceEntity.walletComponent = newComponent
        }

        if let upgradePersistenceComponent = persistenceEntity.upgradeComponent {
            upgradePersistenceComponent.points = Int64(upgradeComponent?.points ?? 0)
        } else {
            let newComponent = UpgradePersistenceComponent(context: store.managedContext)
            newComponent.points = Int64(upgradeComponent?.points ?? 0)
            persistenceEntity.upgradeComponent = newComponent
        }

    }

    private func fetchGameStatePersistenceEntity(sessionId: UUID) -> GameStatePersistenceEntity? {
        guard let session = fetchSession(sessionId: sessionId) else {
            return nil
        }

        return session.gameState
    }

    private func fetchSession(sessionId: UUID) -> Session? {
        let request = Session.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", sessionId as CVarArg)
        return store.fetch(request: request).first
    }

}
