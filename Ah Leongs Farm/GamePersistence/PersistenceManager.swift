//
//  PersistenceManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 1/4/25.
//

import Foundation
import UIKit

class PersistenceManager {
    private static let PollingPeriodSeconds: TimeInterval = 1

    let sessionId: UUID

    private var persistenceMap: [EntityID: GamePersistenceMetaData] = [:]

    private var timer: Timer?
    private var lastObservedEntities: ([any Entity])?

    private var sessionMutation: (any SessionMutation)? = CoreDataSessionMutation()
    private var sessionQuery: (any SessionQuery)? = CoreDataSessionQuery()

    // MARK: - AbstractPlotPersistenceManager
    private(set) var plotMutation: (any PlotMutation)? = CoreDataPlotMutation()
    private(set) var plotQuery: (any PlotQuery)? = CoreDataPlotQuery()

    // MARK: - AbstractGameStatePersistenceManager
    private(set) var gameStateMutation: (any GameStateMutation)? = CoreDataGameStateMutation()
    private(set) var gameStateQuery: (any GameStateQuery)? = CoreDataGameStateQuery()

    // MARK: - AbstractSolarPanelPersistenceManager
    private(set) var solarPanelMutation: (any SolarPanelMutation)? = CoreDataSolarPanelMutation()
    private(set) var solarPanelQuery: (any SolarPanelQuery)? = CoreDataSolarPanelQuery()

    // MARK: - AbstractSeedPersistenceManager
    private(set) var seedQuery: (any SeedQuery)? = CoreDataSeedQuery()
    private(set) var appleSeedMutation: (any SeedMutation<AppleSeed>)? =
        CoreDataSeedMutation<AppleSeed, AppleSeedPersistenceEntity>()
    private(set) var bokChoySeedMutation: (any SeedMutation<BokChoySeed>)? =
        CoreDataSeedMutation<BokChoySeed, BokChoySeedPersistenceEntity>()
    private(set) var potatoSeedMutation: (any SeedMutation<PotatoSeed>)? =
        CoreDataSeedMutation<PotatoSeed, PotatoSeedPersistenceEntity>()

    // MARK: - AbstractCropPersistenceManager
    private(set) var cropQuery: (any CropQuery)? = CoreDataCropQuery()
    private(set) var appleMutation: (any CropMutation<Apple>)? = CoreDataCropMutation<Apple, ApplePersistenceEntity>()
    private(set) var bokChoyMutation: (any CropMutation<BokChoy>)? =
        CoreDataCropMutation<BokChoy, BokChoyPersistenceEntity>()
    private(set) var potatoMutation: (any CropMutation<Potato>)? =
        CoreDataCropMutation<Potato, PotatoPersistenceEntity>()

    init(sessionId: UUID) {
        self.sessionId = sessionId
        startPersistenceTimer()
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

    func persist(entities: [any Entity]) {
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

    private func startPersistenceTimer() {
        timer = Timer.scheduledTimer(
            withTimeInterval: Self.PollingPeriodSeconds, repeats: true
        ) { [weak self] _ in
                self?.flushPendingPersistence()
        }
    }

    private func flushPendingPersistence() {
        guard let lastObservedEntities = lastObservedEntities else {
            return
        }

        persist(entities: lastObservedEntities)
    }

    deinit {
        timer?.invalidate()
    }
}

extension PersistenceManager: IGameObserver {

    func observe(entities: [any Entity]) {
        lastObservedEntities = entities
    }
}

// MARK: - AbstractPlotPersistenceManager
extension PersistenceManager: AbstractPlotPersistenceManager {
}

// MARK: - AbstractGameStatePersistenceManager
extension PersistenceManager: AbstractGameStatePersistenceManager {
}

// MARK: - AbstractSolarPanelPersistenceManager
extension PersistenceManager: AbstractSolarPanelPersistenceManager {
}

// MARK: - AbstractSeedPersistenceManager
extension PersistenceManager: AbstractSeedPersistenceManager {
}

// MARK: - AbstractCropPersistenceManager
extension PersistenceManager: AbstractCropPersistenceManager {
}
