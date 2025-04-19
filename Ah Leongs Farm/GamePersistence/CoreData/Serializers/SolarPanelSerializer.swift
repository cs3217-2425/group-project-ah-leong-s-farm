//
//  SolarPanelSerializer.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 19/4/25.
//

import Foundation

class SolarPanelSerializer {
    private let store: Store

    init(store: Store) {
        self.store = store
    }

    func serialize(id: UUID, solarPanel: SolarPanel) -> SolarPanelPersistenceEntity? {
        guard let persistenceEntity = fetchSolarPanelById(id: id) else {
            return nil
        }

        updateAttributes(solarPanel: solarPanel, persistenceEntity: persistenceEntity)

        return persistenceEntity
    }

    func serializeNew(sessionId: UUID, id: UUID, solarPanel: SolarPanel) -> SolarPanelPersistenceEntity? {
        guard let session = fetchSesssion(sessionId: sessionId) else {
            return nil
        }

        let persistenceEntity = SolarPanelPersistenceEntity(context: store.managedContext)
        persistenceEntity.id = id
        persistenceEntity.session = session

        updateAttributes(solarPanel: solarPanel, persistenceEntity: persistenceEntity)

        return persistenceEntity
    }

    private func updateAttributes(solarPanel: SolarPanel, persistenceEntity: SolarPanelPersistenceEntity) {
        updateIsItemAttribute(solarPanel: solarPanel, persistenceEntity: persistenceEntity)
        updatePositionAttribute(solarPanel: solarPanel, persistenceEntity: persistenceEntity)
    }

    private func updateIsItemAttribute(solarPanel: SolarPanel, persistenceEntity: SolarPanelPersistenceEntity) {
        persistenceEntity.isItem = solarPanel.getComponentByType(ofType: ItemComponent.self) != nil
    }

    private func updatePositionAttribute(solarPanel: SolarPanel, persistenceEntity: SolarPanelPersistenceEntity) {
        guard let positionComponent = solarPanel.getComponentByType(ofType: PositionComponent.self) else {
            persistenceEntity.positionComponent = nil
            return
        }

        if let positionPersistenceComponent = persistenceEntity.positionComponent {
            positionPersistenceComponent.x = Float(positionComponent.x)
            positionPersistenceComponent.y = Float(positionComponent.y)
        } else {
            let newPositionComponent = PositionPersistenceComponent(context: store.managedContext)
            newPositionComponent.x = Float(positionComponent.x)
            newPositionComponent.y = Float(positionComponent.y)
            persistenceEntity.positionComponent = newPositionComponent
        }
    }

    private func fetchSolarPanelById(id: UUID) -> SolarPanelPersistenceEntity? {
        let fetchRequest = SolarPanelPersistenceEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return store.fetch(request: fetchRequest).first
    }

    private func fetchSesssion(sessionId: UUID) -> Session? {
        let fetchRequest = Session.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", sessionId as CVarArg)
        return store.fetch(request: fetchRequest).first
    }
}
