//
//  PersistenceManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 1/4/25.
//

import Foundation

class PersistenceManager {
    private var persistenceMap: [UUID: any GamePersistenceObject] = [:]

    private(set) var plotMutation: (any PlotMutation)? = CoreDataPlotMutation()
    private(set) var farmLandMutation: (any FarmLandMutation)? = CoreDataFarmLandMutation()

    func acceptToSave(visitor: GamePersistenceObject, persistenceId: UUID) {
        let isSuccessfullySaved = visitor.save(manager: self, persistenceId: persistenceId)

        if isSuccessfullySaved {
            persistenceMap[persistenceId] = visitor
        }
    }

    func acceptToDelete(visitor: GamePersistenceObject, persistenceId: UUID) {
        let isSuccessfullyDeleted = visitor.delete(manager: self, persistenceId: persistenceId)

        if isSuccessfullyDeleted {
            persistenceMap.removeValue(forKey: persistenceId)
        }
    }
}

extension PersistenceManager: IGameObserver {

    func observe(entities: [any Entity]) {
        var deletePersistenceMap: [UUID: any GamePersistenceObject] = persistenceMap

        for entity in entities {
            guard let persistenceComponent = entity.getComponentByType(
                ofType: PersistenceComponent.self) else {
                continue
            }

            let persistenceVisitor = persistenceComponent.persistenceVisitor
            let persistenceId = persistenceComponent.persistenceId
            acceptToSave(visitor: persistenceVisitor, persistenceId: persistenceId)

            deletePersistenceMap.removeValue(forKey: persistenceId)
        }

        for (persistenceID, gamePersistenceObject) in deletePersistenceMap {
            acceptToDelete(visitor: gamePersistenceObject, persistenceId: persistenceID)
        }
    }
}

// MARK: - AbstractPlotPersistenceManager
extension PersistenceManager: AbstractPlotPersistenceManager {
}

// MARK: - AbstractFarmLandPersistenceManager
extension PersistenceManager: AbstractFarmLandPersistenceManager {
}
