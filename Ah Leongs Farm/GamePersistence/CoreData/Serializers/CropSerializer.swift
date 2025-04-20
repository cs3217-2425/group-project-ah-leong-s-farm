//
//  CropSerializer.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 18/4/25.
//

import CoreData

class CropSerializer<T: Crop, S: AbstractCropPersistenceEntity> {
    private let store: Store

    init(store: Store) {
        self.store = store
    }

    func serialize(sessionId: UUID, id: UUID, crop: T) -> S? {
        guard let persistenceEntity = fetchPersistenceEntity(id: id) else {
            return nil
        }

        updateAttributes(persistenceEntity: persistenceEntity, crop: crop)
        return persistenceEntity
    }

    func serializeNew(sessionId: UUID, id: UUID, crop: T) -> S? {
        guard let session = fetchSession(sessionId: sessionId) else {
            return nil
        }

        let persistenceEntity = S(context: store.managedContext)
        persistenceEntity.id = id
        persistenceEntity.session = session

        updateAttributes(persistenceEntity: persistenceEntity, crop: crop)

        return nil
    }

    private func updateAttributes(persistenceEntity: S, crop: T) {
        // required attributes
        updateHealthAttribute(persistenceEntity: persistenceEntity, crop: crop)
        updateYieldAttribute(persistenceEntity: persistenceEntity, crop: crop)

        // optional attributes
        updatePositionAttribute(persistenceEntity: persistenceEntity, crop: crop)
        updateGrowthAttribute(persistenceEntity: persistenceEntity, crop: crop)
        updateHarvestedAttribute(persistenceEntity: persistenceEntity, crop: crop)
        updateItemAttribute(persistenceEntity: persistenceEntity, crop: crop)
    }

    private func updatePositionAttribute(persistenceEntity: S, crop: T) {
        guard let positionComponent = crop.getComponentByType(ofType: PositionComponent.self) else {
            persistenceEntity.positionComponent = nil
            return
        }

        if let positionPersistenceComponent = persistenceEntity.positionComponent {
            positionPersistenceComponent.x = Float(positionComponent.x)
            positionPersistenceComponent.y = Float(positionComponent.y)
        } else {
            let newComponent = PositionPersistenceComponent(context: store.managedContext)
            newComponent.x = Float(positionComponent.x)
            newComponent.y = Float(positionComponent.y)
            persistenceEntity.positionComponent = newComponent
        }
    }

    private func updateHealthAttribute(persistenceEntity: S, crop: T) {
        let healthComponent = crop.getComponentByType(ofType: HealthComponent.self)

        if let healthPersistenceComponent = persistenceEntity.healthComponent {
            healthPersistenceComponent.health = healthComponent?.health ?? 0
            healthPersistenceComponent.maxHealth = healthComponent?.maxHealth ?? 0
        } else {
            let newComponent = HealthPersistenceComponent(context: store.managedContext)
            newComponent.health = healthComponent?.health ?? 0
            newComponent.maxHealth = healthComponent?.maxHealth ?? 0
            persistenceEntity.healthComponent = newComponent
        }
    }

    private func updateYieldAttribute(persistenceEntity: S, crop: T) {
        let yieldComponent = crop.getComponentByType(ofType: YieldComponent.self)

        if let yieldPersistenceComponent = persistenceEntity.yieldComponent {
            yieldPersistenceComponent.yield = Int64(yieldComponent?.yield ?? 0)
            yieldPersistenceComponent.maxYield = Int64(yieldComponent?.maxYield ?? 0)
        } else {
            let newComponent = YieldPersistenceComponent(context: store.managedContext)
            newComponent.yield = Int64(yieldComponent?.yield ?? 0)
            newComponent.maxYield = Int64(yieldComponent?.maxYield ?? 0)
            persistenceEntity.yieldComponent = newComponent
        }
    }

    private func updateGrowthAttribute(persistenceEntity: S, crop: T) {
        guard let growthComponent = crop.getComponentByType(ofType: GrowthComponent.self) else {
            persistenceEntity.growthComponent = nil
            return
        }

        if let growthPersistenceComponent = persistenceEntity.growthComponent {
            growthPersistenceComponent.currentGrowthTurn = growthComponent.currentGrowthTurn
            growthPersistenceComponent.totalGrowthTurns = Int64(growthComponent.totalGrowthTurns)
            growthPersistenceComponent.totalGrowthStages = Int64(growthComponent.totalGrowthStages)
        } else {
            let newComponent = GrowthPersistenceComponent(context: store.managedContext)
            newComponent.currentGrowthTurn = growthComponent.currentGrowthTurn
            newComponent.totalGrowthTurns = Int64(growthComponent.totalGrowthTurns)
            newComponent.totalGrowthStages = Int64(growthComponent.totalGrowthStages)
            persistenceEntity.growthComponent = newComponent
        }
    }

    private func updateHarvestedAttribute(persistenceEntity: S, crop: T) {
        guard crop.getComponentByType(ofType: HarvestedComponent.self) != nil else {
            persistenceEntity.harvestedComponent = nil
            return
        }

        if persistenceEntity.growthComponent == nil {
            let newComponent = HarvestedPersistenceComponent(context: store.managedContext)
            persistenceEntity.harvestedComponent = newComponent
        }
    }

    private func updateItemAttribute(persistenceEntity: S, crop: T) {
        guard crop.getComponentByType(ofType: HarvestedComponent.self) != nil else {
            persistenceEntity.itemComponent = nil
            return
        }

        if persistenceEntity.itemComponent == nil {
            let newComponent = ItemPersistenceComponent(context: store.managedContext)
            persistenceEntity.itemComponent = newComponent
        }
    }

    private func fetchPersistenceEntity(id: UUID) -> S? {
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let request = S.fetchRequest()
        request.predicate = predicate

        return store.fetch(request: request).first as? S
    }

    private func fetchSession(sessionId: UUID) -> Session? {
        let predicate = NSPredicate(format: "id == %@", sessionId as CVarArg)
        let request = Session.fetchRequest()
        request.predicate = predicate

        return store.fetch(request: request).first
    }
}
