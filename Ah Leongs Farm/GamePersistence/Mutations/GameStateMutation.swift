//
//  GameStateMutation.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/4/25.
//

protocol GameStateMutation {
    func upsertGameState(_ gameState: GameState) -> Bool

    func deleteGameState() -> Bool
}
