//
//  SeedSerializer.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 19/4/25.
//

import Foundation

class SeedSerializer<T: Seed, S: AbstractSeedPersistenceEntity> {
    private let store: Store

    init(store: Store) {
        self.store = store
    }

    func serialize(sessionId: UUID, id: UUID, seed: T) -> S? {
        guard let persistenceEntity = fetchSeedById(id: id) else {
            return nil
        }

        return persistenceEntity
    }

    func serializeNew(sessionId: UUID, id: UUID, seed: T) -> S? {
        guard let session = fetchSession(sessionId: sessionId) else {
            return nil
        }

        let persistenceEntity = S(context: store.managedContext)
        persistenceEntity.id = id
        persistenceEntity.session = session

        return persistenceEntity
    }

    private func fetchSession(sessionId: UUID) -> Session? {
        let predicate = NSPredicate(format: "id == %@", sessionId as CVarArg)
        let fetchRequest = Session.fetchRequest()
        fetchRequest.predicate = predicate

        return store.fetch(request: fetchRequest).first
    }

    private func fetchSeedById(id: UUID) -> S? {
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let fetchRequest = S.fetchRequest()
        fetchRequest.predicate = predicate

        return store.fetch(request: fetchRequest).first as? S
    }
}
