//
//  GameStateMutation.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/4/25.
//

import Foundation

protocol GameStateMutation {
    func upsertGameState(sessionId: UUID, gameState: GameState) -> Bool

    func deleteGameState(sessionId: UUID) -> Bool
}
