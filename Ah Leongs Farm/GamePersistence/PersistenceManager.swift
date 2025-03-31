//
//  PersistenceManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 1/4/25.
//

class PersistenceManager {
    func accept(visitor: PersistenceVisitor) {
        visitor.visitPersistenceManager(manager: self)
    }

    func save(plot: Plot) {
    }

    func save(farmLand: FarmLand) {
    }

    func save(gameState: GameState) {
    }

    func save(bokChoy: BokChoy) {
    }

    func save(quest: Quest) {
    }
}
