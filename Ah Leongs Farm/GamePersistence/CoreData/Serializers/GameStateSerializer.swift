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
        let components = extractGameStateComponents(from: gameState)

        updateEnergyComponent(persistenceEntity: persistenceEntity, componentData: components.energy)
        updateLevelComponent(persistenceEntity: persistenceEntity, componentData: components.level)
        updateTurnComponent(persistenceEntity: persistenceEntity, componentData: components.turn)
        updateWalletComponent(persistenceEntity: persistenceEntity, componentData: components.wallet)
        updateUpgradeComponent(persistenceEntity: persistenceEntity, componentData: components.upgrade)
    }

    private struct GameStateComponentData {
        let energy: EnergyBankComponent?
        let level: LevelComponent?
        let turn: TurnComponent?
        let wallet: WalletComponent?
        let upgrade: UpgradeComponent?
    }

    private func extractGameStateComponents(from gameState: GameState) -> GameStateComponentData {
        GameStateComponentData(
            energy: gameState.getComponentByType(ofType: EnergyBankComponent.self),
            level: gameState.getComponentByType(ofType: LevelComponent.self),
            turn: gameState.getComponentByType(ofType: TurnComponent.self),
            wallet: gameState.getComponentByType(ofType: WalletComponent.self),
            upgrade: gameState.getComponentByType(ofType: UpgradeComponent.self)
        )
    }

    private func updateEnergyComponent(persistenceEntity: GameStatePersistenceEntity,
                                       componentData: EnergyBankComponent?) {
        let currentEnergy = Int64(componentData?.getCurrentEnergy(of: .base) ?? 0)
        let maxEnergy = Int64(componentData?.getMaxEnergy(of: .base) ?? 0)

        if let existingComponent = persistenceEntity.energyComponent {
            existingComponent.currentBaseEnergy = currentEnergy
            existingComponent.maxBaseEnergy = maxEnergy
        } else {
            let newComponent = EnergyPersistenceComponent(context: store.managedContext)
            newComponent.currentBaseEnergy = currentEnergy
            newComponent.maxBaseEnergy = maxEnergy
            persistenceEntity.energyComponent = newComponent
        }
    }

    private func updateLevelComponent(persistenceEntity: GameStatePersistenceEntity, componentData: LevelComponent?) {
        let level = Int64(componentData?.level ?? 0)
        let currentXP = componentData?.currentXP ?? 0

        if let existingComponent = persistenceEntity.levelComponent {
            existingComponent.level = level
            existingComponent.currentXP = currentXP
        } else {
            let newComponent = LevelPersistenceComponent(context: store.managedContext)
            newComponent.level = level
            newComponent.currentXP = currentXP
            persistenceEntity.levelComponent = newComponent
        }
    }

    private func updateTurnComponent(persistenceEntity: GameStatePersistenceEntity, componentData: TurnComponent?) {
        let currentTurn = Int64(componentData?.currentTurn ?? 0)
        let maxTurns = Int64(componentData?.maxTurns ?? 0)

        if let existingComponent = persistenceEntity.turnComponent {
            existingComponent.currentTurn = currentTurn
            existingComponent.maxTurns = maxTurns
        } else {
            let newComponent = TurnPersistenceComponent(context: store.managedContext)
            newComponent.currentTurn = currentTurn
            newComponent.maxTurns = maxTurns
            persistenceEntity.turnComponent = newComponent
        }
    }

    private func updateWalletComponent(persistenceEntity: GameStatePersistenceEntity, componentData: WalletComponent?) {
        let coinAmount = Double(componentData?.getAmount(of: .coin) ?? 0)

        if let existingComponent = persistenceEntity.walletComponent {
            existingComponent.coinAmount = coinAmount
        } else {
            let newComponent = WalletPersistenceComponent(context: store.managedContext)
            newComponent.coinAmount = coinAmount
            persistenceEntity.walletComponent = newComponent
        }
    }

    private func updateUpgradeComponent(persistenceEntity: GameStatePersistenceEntity,
                                        componentData: UpgradeComponent?) {
        let points = Int64(componentData?.points ?? 0)

        if let existingComponent = persistenceEntity.upgradeComponent {
            existingComponent.points = points
        } else {
            let newComponent = UpgradePersistenceComponent(context: store.managedContext)
            newComponent.points = points
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
