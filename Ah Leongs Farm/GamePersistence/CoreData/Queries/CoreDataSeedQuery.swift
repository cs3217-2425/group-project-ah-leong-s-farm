//
//  CoreDataSeedQuery.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 19/4/25.
//

import Foundation
import UIKit

class CoreDataSeedQuery: SeedQuery {
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

    func fetch(sessionId: UUID) -> [any Seed] {
        guard let session = fetchSession(sessionId: sessionId) else {
            return []
        }

        return session.seeds?.allObjects
            .compactMap { $0 as? SeedDeserializable }
            .map { $0.deserialize() } ?? []
    }

    private func fetchSession(sessionId: UUID) -> Session? {
        let request = Session.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", sessionId as CVarArg)

        return store.fetch(request: request).first
    }
}
