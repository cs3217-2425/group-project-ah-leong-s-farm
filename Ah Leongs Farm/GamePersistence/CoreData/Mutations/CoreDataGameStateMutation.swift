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

    func upsertGameState(sessionId: UUID, gameState: GameState) -> Bool {
        guard gameStateSerializer.serialize(sessionId: sessionId, gameState: gameState) ??
            gameStateSerializer.serializeNew(sessionId: sessionId, gameState: gameState) != nil else {
            return false
        }

        return true
    }

    func deleteGameState(sessionId: UUID) -> Bool {
        guard let gameState = fetchSession(sessionId: sessionId)?.gameState else {
            return false
        }

        store.managedContext.delete(gameState)

        return true
    }

    private func fetchSession(sessionId: UUID) -> Session? {
        let fetchRequest = Session.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", sessionId as CVarArg)

        return store.fetch(request: fetchRequest).first
    }

}
