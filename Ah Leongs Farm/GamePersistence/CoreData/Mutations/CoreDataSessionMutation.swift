//
//  CoreDataSessionMutation.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 15/4/25.
//

import UIKit

class CoreDataSessionMutation: SessionMutation {
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

    func upsertSession(session: SessionData) -> Bool {
        if fetchSession(id: session.id) != nil {
            return true
        }

        let newSession = Session(context: store.managedContext)
        newSession.id = session.id

        do {
            try store.save()
        } catch {
            store.rollback()
            return false
        }

        return true
    }

    func deleteSession(id: UUID) -> Bool {
        guard let session = fetchSession(id: id) else {
            return false
        }

        store.managedContext.delete(session)

        do {
            try store.save()
        } catch {
            store.rollback()
            return false
        }
        
        return true
    }

    private func fetchSession(id: UUID) -> Session? {
        let fetchRequest = Session.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        return store.fetch(request: fetchRequest).first

    }

}
