//
//  CoreDataFarmLandMutation.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/4/25.
//

import UIKit

class CoreDataFarmLandMutation: FarmLandMutation {
    private let store: Store
    private let farmLandSerializer: FarmLandSerializer

    init(store: Store) {
        self.store = store
        farmLandSerializer = FarmLandSerializer(store: store)
    }

    convenience init?() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }

        self.init(store: appDelegate.persistentContainer)
    }

    func upsertFarmLand(id: UUID, farmLand: FarmLand) -> Bool {
        let farmLandPersistenceEntity = farmLandSerializer.serialize(id: id, farmLand: farmLand) ??
            farmLandSerializer.serializeNew(id: id, farmLand: farmLand)

        do {
            try store.save()
        } catch {
            store.rollback()
            return false
        }

        return true
    }

    func deleteFarmLand(id: UUID) -> Bool {
        guard let farmLandPersistenceEntity = fetchPersistenceEntityByID(id: id) else {
            // No need to delete if the entity doesn't exist
            return true
        }

        store.managedContext.delete(farmLandPersistenceEntity)

        do {
            try store.save()
        } catch {
            store.rollback()
            return false
        }

        return true
    }

    func fetchPersistenceEntityByID(id: UUID) -> FarmLandPersistenceEntity? {
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let request = FarmLandPersistenceEntity.fetchRequest()
        request.predicate = predicate

        return store.fetch(request: request).first
    }


}
