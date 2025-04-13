//
//  AbstractFarmLandPersistenceManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/4/25.
//

import Foundation

protocol AbstractFarmLandPersistenceManager {
    var farmLandMutation: FarmLandMutation? { get }
}

extension AbstractFarmLandPersistenceManager {
    func save(farmLand: FarmLand, persistenceId: UUID) -> Bool {
        guard let farmLandMutation = farmLandMutation else {
            return false
        }

        let isSuccessfullyMutated = farmLandMutation.upsertFarmLand(id: persistenceId, farmLand: farmLand)

        return isSuccessfullyMutated
    }

    func delete(farmLand: FarmLand, persistenceId: UUID) -> Bool {
        guard let farmLandMutation = farmLandMutation else {
            return false
        }

        let isSuccessfullyDeleted = farmLandMutation.deleteFarmLand(id: persistenceId)

        return isSuccessfullyDeleted
    }
}
