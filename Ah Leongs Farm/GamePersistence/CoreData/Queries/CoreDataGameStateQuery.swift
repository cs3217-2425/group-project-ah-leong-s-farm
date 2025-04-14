//
//  CoreDataGameStateQuery.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/4/25.
//

import UIKit

class CoreDataGameStateQuery: GameStateQuery {

    private let store: Store

    init(store: Store) {
        self.store = store
    }

    convenience init?() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }

        self.init(store: appDelegate.persistentContainer)
    }

    func fetch() -> GameState? {
        let request = GameStatePersistenceEntity.fetchRequest()

        guard let gameStatePersistenceEntity = store.fetch(request: request).first else {
            return nil
        }

        return gameStatePersistenceEntity.deserialize()
    }
}
