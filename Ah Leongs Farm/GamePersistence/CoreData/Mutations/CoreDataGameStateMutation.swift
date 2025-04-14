//
//  CoreDataGameStateMutation.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/4/25.
//

import UIKit

class CoreDataGameStateMutation: GameStateMutation {
    private let store: Store
    private let gameStateSerializer: GameStateSerializer

    init(store: Store) {
        self.store = store
        gameStateSerializer = GameStateSerializer(store: store)
    }

    convenience init?() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }

        self.init(store: appDelegate.persistentContainer)
    }

    func upsertGameState(_ gameState: GameState) -> Bool {
        _ = gameStateSerializer.serialize(gameState: gameState) ??
            gameStateSerializer.serializeNew(gameState: gameState)

        do {
            try store.save()
        } catch {
            store.rollback()
            return false
        }

        return true
    }

    func deleteGameState() -> Bool {
        let fetchRequest = GameStatePersistenceEntity.fetchRequest()
        let existingGameStatePersistenceEntities = store.fetch(request: fetchRequest)

        for persistenceEntity in existingGameStatePersistenceEntities {
            store.managedContext.delete(persistenceEntity)
        }

        do {
            try store.save()
        } catch {
            store.rollback()
            return false
        }

        return true
    }
}
