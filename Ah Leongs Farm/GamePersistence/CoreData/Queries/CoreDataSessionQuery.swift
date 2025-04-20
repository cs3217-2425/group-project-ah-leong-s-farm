//
//  CoreDataSessionQuery.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 15/4/25.
//

import UIKit

class CoreDataSessionQuery: SessionQuery {
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

    func fetch() -> [SessionData] {
        let request = Session.fetchRequest()
        return store.fetch(request: request)
            .compactMap { session in
                guard let id = session.id else {
                    return nil
                }
                return SessionData(id: id)
            }
    }

    func fetchById(sessionId: UUID) -> SessionData? {
        let request = Session.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", sessionId as CVarArg)
        request.predicate = predicate

        guard store.fetch(request: request).first != nil else {
            return nil
        }

        return SessionData(id: sessionId)
    }
}
