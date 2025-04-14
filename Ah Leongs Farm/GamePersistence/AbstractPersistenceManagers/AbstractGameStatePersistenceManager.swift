//
//  AbstractGameStatePersistenceManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/4/25.
//

protocol AbstractGameStatePersistenceManager {
    var gameStateMutation: GameStateMutation? { get }
}

extension AbstractGameStatePersistenceManager {
    func save(gameState: GameState) -> Bool {
        guard let gameStateMutation = gameStateMutation else {
            return false
        }

        let isSuccessfullyMutated = gameStateMutation.upsertGameState(gameState)

        return isSuccessfullyMutated
    }

    func delete(gameState: GameState) -> Bool {
        guard let gameStateMutation = gameStateMutation else {
            return false
        }

        let isSuccessfullyDeleted = gameStateMutation.deleteGameState()

        return isSuccessfullyDeleted
    }
}
