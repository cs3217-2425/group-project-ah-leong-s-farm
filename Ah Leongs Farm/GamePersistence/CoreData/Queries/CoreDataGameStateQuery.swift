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

    func fetch(sessionId: UUID) -> GameState? {
        guard let session = fetchSession(sessionId: sessionId) else {
            return nil
        }

        return session.gameState?.deserialize()
    }

    private func fetchSession(sessionId: UUID) -> Session? {
        let request = Session.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", sessionId as CVarArg)

        return store.fetch(request: request).first
    }

}
