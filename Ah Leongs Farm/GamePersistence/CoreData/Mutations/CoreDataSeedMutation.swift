//
//  CoreDataSeedMutation.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 19/4/25.
//

import UIKit

class CoreDataSeedMutation<T: Seed, S: AbstractSeedPersistenceEntity>: SeedMutation {

    private let store: Store
    private let serializer: SeedSerializer<T, S>
    private let shouldSave: Bool

    init(store: Store, shouldSave: Bool = false) {
        self.store = store
        self.serializer = SeedSerializer<T, S>(store: store)
        self.shouldSave = shouldSave
    }

    convenience init?(shouldSave: Bool = false) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }

        self.init(store: appDelegate.persistentContainer, shouldSave: shouldSave)
    }

    func upsertSeed(sessionId: UUID, id: UUID, seed: T) -> Bool {
        guard (serializer.serialize(sessionId: sessionId, id: id, seed: seed)
               ?? serializer.serializeNew(sessionId: sessionId, id: id, seed: seed)) != nil else {
            return false
        }

        if shouldSave {
            do {
                try store.managedContext.save()
            } catch {
                store.rollback()
                return false
            }
        }

        return true
    }

    func deleteSeed(id: UUID, seed: T) -> Bool {
        guard let persistenceEntity = fetchSeedById(id: id) else {
            return false
        }

        store.managedContext.delete(persistenceEntity)

        if shouldSave {
            do {
                try store.managedContext.save()
            } catch {
                store.rollback()
                return false
            }
        }

        return true
    }

    private func fetchSeedById(id: UUID) -> S? {
        let request = S.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        return store.fetch(request: request).first as? S
    }

}
