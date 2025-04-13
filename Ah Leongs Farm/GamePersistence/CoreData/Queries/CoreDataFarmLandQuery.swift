//
//  CoreDataFarmLandQuery.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/4/25.
//

import UIKit

class CoreDataFarmLandQuery: FarmLandQuery {
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

    func fetch() -> [FarmLand] {
        let request = FarmLandPersistenceEntity.fetchRequest()

        return store.fetch(request: request)
            .map({ $0.deserialize() })
    }

    func fetchById(id: UUID) -> FarmLand? {
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let request = FarmLandPersistenceEntity.fetchRequest()
        request.predicate = predicate

        return store.fetch(request: request)
            .map({ $0.deserialize() })
            .first
    }
}
