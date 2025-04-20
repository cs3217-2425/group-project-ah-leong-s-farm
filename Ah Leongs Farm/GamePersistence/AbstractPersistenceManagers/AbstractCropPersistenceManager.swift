//
//  AbstractCropPersistenceManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 18/4/25.
//

import Foundation

protocol AbstractCropPersistenceManager {
    var sessionId: UUID { get }
    var cropQuery: (any CropQuery)? { get }
    var appleMutation: (any CropMutation<Apple>)? { get }
    var bokChoyMutation: (any CropMutation<BokChoy>)? { get }
    var potatoMutation: (any CropMutation<Potato>)? { get }
}

extension AbstractCropPersistenceManager {
    func loadCrops() -> [any Crop] {
        guard let cropQuery = cropQuery else {
            return []
        }

        return cropQuery.fetch(sessionId: sessionId)
    }

    func save(apple: Apple, persistenceId: UUID) -> Bool {
        guard let appleMutation = appleMutation else {
            return false
        }

        let isSuccessfullyMutated = appleMutation.upsertCrop(
            sessionId: sessionId,
            id: persistenceId,
            crop: apple
        )

        return isSuccessfullyMutated
    }

    func delete(apple: Apple, persistenceId: UUID) -> Bool {
        guard let appleMutation = appleMutation else {
            return false
        }

        let isSuccessfullyDeleted = appleMutation.deleteCrop(id: persistenceId)

        return isSuccessfullyDeleted
    }

    func save(bokChoy: BokChoy, persistenceId: UUID) -> Bool {
        guard let bokChoyMutation = bokChoyMutation else {
            return false
        }

        let isSuccessfullyMutated = bokChoyMutation.upsertCrop(
            sessionId: sessionId,
            id: persistenceId,
            crop: bokChoy
        )

        return isSuccessfullyMutated
    }

    func delete(bokChoy: BokChoy, persistenceId: UUID) -> Bool {
        guard let bokChoyMutation = bokChoyMutation else {
            return false
        }

        let isSuccessfullyDeleted = bokChoyMutation.deleteCrop(id: persistenceId)

        return isSuccessfullyDeleted
    }

    func save(potato: Potato, persistenceId: UUID) -> Bool {
        guard let potatoMutation = potatoMutation else {
            return false
        }

        let isSuccessfullyMutated = potatoMutation.upsertCrop(
            sessionId: sessionId,
            id: persistenceId,
            crop: potato
        )

        return isSuccessfullyMutated
    }

    func delete(potato: Potato, persistenceId: UUID) -> Bool {
        guard let appleMutation = appleMutation else {
            return false
        }

        let isSuccessfullyDeleted = appleMutation.deleteCrop(id: persistenceId)

        return isSuccessfullyDeleted
    }
}
