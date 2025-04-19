//
//  PersistenceManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 1/4/25.
//

import Foundation

class PersistenceManager {
    let sessionId: UUID

    private var persistenceMap: [EntityID: GamePersistenceMetaData] = [:]

    private var sessionMutation: (any SessionMutation)? = CoreDataSessionMutation()
    private var sessionQuery: (any SessionQuery)? = CoreDataSessionQuery()

    // MARK: - AbstractPlotPersistenceManager
    private(set) var plotMutation: (any PlotMutation)? = CoreDataPlotMutation()
    private(set) var plotQuery: (any PlotQuery)? = CoreDataPlotQuery()

    // MARK: - AbstractGameStatePersistenceManager
    private(set) var gameStateMutation: (any GameStateMutation)? = CoreDataGameStateMutation()
    private(set) var gameStateQuery: (any GameStateQuery)? = CoreDataGameStateQuery()

    // MARK: - AbstractSeedPersistenceManager
    private(set) var seedQuery: (any SeedQuery)? = CoreDataSeedQuery()
    private(set) var appleSeedMutation: (any SeedMutation<AppleSeed>)? =
        CoreDataSeedMutation<AppleSeed, AppleSeedPersistenceEntity>()
    private(set) var bokChoySeedMutation: (any SeedMutation<BokChoySeed>)? =
        CoreDataSeedMutation<BokChoySeed, BokChoySeedPersistenceEntity>()
    private(set) var potatoSeedMutation: (any SeedMutation<PotatoSeed>)? =
        CoreDataSeedMutation<PotatoSeed, PotatoSeedPersistenceEntity>()

    init(sessionId: UUID) {
        self.sessionId = sessionId
    }

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

    func hasSessionPersisted() -> Bool {
        guard let sessionQuery = sessionQuery else {
            return false
        }

        return sessionQuery.doesSessionExist(sessionId: sessionId)
    }

    private func createSessionIfNeeded() -> Bool {
        guard let sessionMutation = sessionMutation else {
            return false
        }

        let sessionData = SessionData(id: sessionId)

        return sessionMutation.upsertSession(session: sessionData)
    }
}

extension PersistenceManager: IGameObserver {

    func observe(entities: [any Entity]) {
        guard createSessionIfNeeded() else {
            return
        }

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

// MARK: - AbstractSeedPersistenceManager
extension PersistenceManager: AbstractSeedPersistenceManager {
}
