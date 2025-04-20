//
//  CoreDataCropMutation.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 18/4/25.
//

import UIKit

class CoreDataCropMutation<T: Crop, S: AbstractCropPersistenceEntity>: CropMutation {
    private let store: Store
    private let serializer: CropSerializer<T, S>

    init(store: Store) {
        self.store = store
        self.serializer = CropSerializer<T, S>(store: store)
    }

    convenience init?() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }

        self.init(store: appDelegate.persistentContainer)
    }

    func upsertCrop(sessionId: UUID, id: UUID, crop: T) -> Bool {
        guard serializer.serialize(sessionId: sessionId, id: id, crop: crop) ?? serializer
            .serializeNew(sessionId: sessionId, id: id, crop: crop) != nil else {
            return false
        }

        do {
            try store.save()
        } catch {
            store.rollback()
            return false
        }

        return true
    }

    func deleteCrop(id: UUID) -> Bool {
        guard let persistenceEntity = fetchCropById(id: id) else {
            return false
        }

        store.managedContext.delete(persistenceEntity)

        do {
            try store.save()
        } catch {
            store.rollback()
            return false
        }

        return false
    }

    private func fetchCropById(id: UUID) -> S? {
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let request = S.fetchRequest()
        request.predicate = predicate

        return store.fetch(request: request).first as? S
    }
}
