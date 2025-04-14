//
//  PersistenceManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 1/4/25.
//

import Foundation

class PersistenceManager {
    private var persistenceMap: [EntityID: GamePersistenceMetaData] = [:]

    private(set) var plotMutation: (any PlotMutation)? = CoreDataPlotMutation()
    private(set) var gameStateMutation: (any GameStateMutation)? = CoreDataGameStateMutation()

    func acceptToSave(visitor: GamePersistenceObject, persistenceId: UUID) {
        let isSuccessfullySaved = visitor.save(manager: self, persistenceId: persistenceId)

        if isSuccessfullySaved {
            persistenceMap[visitor.id] = GamePersistenceMetaData(
                persistenceId: persistenceId,
                persistenceObject: visitor
            )
        }
    }

    func acceptToDelete(visitor: GamePersistenceObject, persistenceId: UUID) {
        let isSuccessfullyDeleted = visitor.delete(manager: self, persistenceId: persistenceId)

        if isSuccessfullyDeleted {
            persistenceMap.removeValue(forKey: visitor.id)
        }
    }
}

extension PersistenceManager: IGameObserver {

    func observe(entities: [any Entity]) {
        var deletePersistenceMap: [EntityID: GamePersistenceMetaData] = persistenceMap

        for entity in entities {
            guard let persistenceComponent = entity.getComponentByType(
                ofType: PersistenceComponent.self) else {
                continue
            }

            let persistenceVisitor = persistenceComponent.persistenceObject
            let persistenceId = persistenceComponent.persistenceId
            acceptToSave(visitor: persistenceVisitor, persistenceId: persistenceId)

            deletePersistenceMap.removeValue(forKey: entity.id)
        }

        for metaData in deletePersistenceMap.values {
            acceptToDelete(visitor: metaData.persistenceObject, persistenceId: metaData.persistenceId)
        }
    }
}

// MARK: - AbstractPlotPersistenceManager
extension PersistenceManager: AbstractPlotPersistenceManager {
}

// MARK: - AbstractGameStatePersistenceManager
extension PersistenceManager: AbstractGameStatePersistenceManager {
}
