//
//  CoreDataPlotQuery.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/4/25.
//

import UIKit

class CoreDataPlotQuery: PlotQuery {
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

    func fetch() -> [Plot] {
        let request = PlotPersistenceEntity.fetchRequest()

        return store.fetch(request: request)
            .map({ $0.deserialize() })
    }

    func fetchById(id: UUID) -> Plot? {
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let request = PlotPersistenceEntity.fetchRequest()
        request.predicate = predicate

        return store.fetch(request: request)
            .map({ $0.deserialize() })
            .first
    }
}
