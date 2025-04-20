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
    private let shouldSave: Bool

    init(store: Store, shouldSave: Bool = false) {
        self.store = store
        gameStateSerializer = GameStateSerializer(store: store)
        self.shouldSave = shouldSave
    }

    convenience init?(shouldSave: Bool = false) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }

        self.init(store: appDelegate.persistentContainer, shouldSave: shouldSave)
    }

    func upsertGameState(sessionId: UUID, gameState: GameState) -> Bool {
        guard gameStateSerializer.serialize(sessionId: sessionId, gameState: gameState) ??
            gameStateSerializer.serializeNew(sessionId: sessionId, gameState: gameState) != nil else {
            return false
        }

        if shouldSave {
            do {
                try store.managedContext.save()
            } catch {
                store.rollback()
                return false
            }
        }

        return true
    }

    func deleteGameState(sessionId: UUID) -> Bool {
        guard let gameState = fetchSession(sessionId: sessionId)?.gameState else {
            return false
        }

        store.managedContext.delete(gameState)

        if shouldSave {
            do {
                try store.managedContext.save()
            } catch {
                store.rollback()
                return false
            }
        }

        return true
    }

    private func fetchSession(sessionId: UUID) -> Session? {
        let fetchRequest = Session.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", sessionId as CVarArg)

        return store.fetch(request: fetchRequest).first
    }

}
