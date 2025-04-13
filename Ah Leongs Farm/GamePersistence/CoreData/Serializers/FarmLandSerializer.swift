//
//  FarmLandSerializer.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/4/25.
//

import Foundation

class FarmLandSerializer {
    private let store: Store

    init(store: Store) {
        self.store = store
    }

    func serialize(id: UUID, farmLand: FarmLand) -> FarmLandPersistenceEntity? {
        guard let farmLandPersistenceEntity = fetchPersistenceEntity(id: id) else {
            return nil
        }

        updateAttributes(farmLandPersistenceEntity: farmLandPersistenceEntity, farmLand: farmLand)
        return farmLandPersistenceEntity
    }

    func serializeNew(id: UUID, farmLand: FarmLand) -> FarmLandPersistenceEntity {
        let farmLandPersistenceEntity = FarmLandPersistenceEntity(context: store.managedContext)
        farmLandPersistenceEntity.id = id

        updateAttributes(farmLandPersistenceEntity: farmLandPersistenceEntity, farmLand: farmLand)
        return farmLandPersistenceEntity
    }

    private func updateAttributes(farmLandPersistenceEntity: FarmLandPersistenceEntity,
                                  farmLand: FarmLand) {
        let gridComponent = farmLand.getComponentByType(ofType: GridComponent.self)
        farmLandPersistenceEntity.gridRows = Int64(gridComponent?.numberOfRows ?? 0)
        farmLandPersistenceEntity.gridColumns = Int64(gridComponent?.numberOfColumns ?? 0)
    }

    private func fetchPersistenceEntity(id: UUID) -> FarmLandPersistenceEntity? {
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let request = FarmLandPersistenceEntity.fetchRequest()
        request.predicate = predicate

        return store.fetch(request: request).first
    }
}
