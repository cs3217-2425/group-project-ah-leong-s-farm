//
//  AbstractGameStatePersistenceManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/4/25.
//

import Foundation

protocol AbstractGameStatePersistenceManager {
    var sessionId: UUID { get }
    var gameStateQuery: GameStateQuery? { get }
    var gameStateMutation: GameStateMutation? { get }
}

extension AbstractGameStatePersistenceManager {
    func loadGameState() -> GameState? {
        gameStateQuery?.fetch(sessionId: sessionId)
    }

    func save(gameState: GameState) -> Bool {
        guard let gameStateMutation = gameStateMutation else {
            return false
        }

        let isSuccessfullyMutated = gameStateMutation.upsertGameState(sessionId: sessionId, gameState: gameState)

        return isSuccessfullyMutated
    }

    func delete(gameState: GameState) -> Bool {
        guard let gameStateMutation = gameStateMutation else {
            return false
        }

        let isSuccessfullyDeleted = gameStateMutation.deleteGameState(sessionId: sessionId)
        return isSuccessfullyDeleted
    }
}
