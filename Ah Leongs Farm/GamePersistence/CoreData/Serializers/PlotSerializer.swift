//
//  PlotSerializer.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/4/25.
//

import Foundation

class PlotSerializer {

    private let store: Store

    init(store: Store) {
        self.store = store
    }

    func serialize(sessionId: UUID, id: UUID, plot: Plot) -> PlotPersistenceEntity? {
        guard let plotPersistenceEntity = fetchPersistenceEntity(id: id) else {
            return nil
        }

        updateAttributes(plotPersistenceEntity: plotPersistenceEntity, plot: plot)

        return plotPersistenceEntity
    }

    func serializeNew(sessionId: UUID, id: UUID, plot: Plot) -> PlotPersistenceEntity? {
        guard let session = fetchSession(sessionId: sessionId) else {
            return nil
        }

        let plotPersistenceEntity = PlotPersistenceEntity(context: store.managedContext)
        plotPersistenceEntity.id = id

        let plots = session.plots ?? NSSet()
        session.plots = NSSet(set: plots.adding(plotPersistenceEntity))

        updateAttributes(plotPersistenceEntity: plotPersistenceEntity, plot: plot)

        return plotPersistenceEntity
    }

    private func updateAttributes(plotPersistenceEntity: PlotPersistenceEntity, plot: Plot) {
        let positionComponent = plot.getComponentByType(ofType: PositionComponent.self)
        let soilComponent = plot.getComponentByType(ofType: SoilComponent.self)

        if let positionPersistenceComponent = plotPersistenceEntity.positionComponent {
            positionPersistenceComponent.x = Float(positionComponent?.x ?? 0)
            positionPersistenceComponent.y = Float(positionComponent?.y ?? 0)
        } else {
            let newComponent = PositionPersistenceComponent(context: store.managedContext)
            newComponent.x = Float(positionComponent?.x ?? 0)
            newComponent.y = Float(positionComponent?.y ?? 0)
            plotPersistenceEntity.positionComponent = newComponent
        }

        if let soilPersistenceComponent = plotPersistenceEntity.soilComponent {
            soilPersistenceComponent.quality = soilComponent?.quality ?? 0
            soilPersistenceComponent.moisture = soilComponent?.moisture ?? 0
        } else {
            let newComponent = SoilPersistenceComponent(context: store.managedContext)
            newComponent.quality = soilComponent?.quality ?? 0
            newComponent.moisture = soilComponent?.moisture ?? 0
            plotPersistenceEntity.soilComponent = newComponent
        }
    }

    private func fetchPersistenceEntity(id: UUID) -> PlotPersistenceEntity? {
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let request = PlotPersistenceEntity.fetchRequest()
        request.predicate = predicate

        return store.fetch(request: request).first
    }

    private func fetchSession(sessionId: UUID) -> Session? {
        let predicate = NSPredicate(format: "id == %@", sessionId as CVarArg)
        let request = Session.fetchRequest()
        request.predicate = predicate

        return store.fetch(request: request).first
    }

}
