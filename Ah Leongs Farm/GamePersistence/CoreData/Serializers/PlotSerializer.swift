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

    func serialize(id: UUID, plot: Plot) -> PlotPersistenceEntity? {
        guard let plotPersistenceEntity = fetchPersistenceEntity(id: id) else {
            return nil
        }

        updateAttributes(plotPersistenceEntity: plotPersistenceEntity, plot: plot)

        return plotPersistenceEntity
    }

    func serializeNew(id: UUID, plot: Plot) -> PlotPersistenceEntity {
        let plotPersistenceEntity = PlotPersistenceEntity(context: store.managedContext)
        plotPersistenceEntity.id = id

        updateAttributes(plotPersistenceEntity: plotPersistenceEntity, plot: plot)

        return plotPersistenceEntity
    }

    private func updateAttributes(plotPersistenceEntity: PlotPersistenceEntity, plot: Plot) {
        let positionComponent = plot.getComponentByType(ofType: PositionComponent.self)
        let soilComponent = plot.getComponentByType(ofType: SoilComponent.self)

        plotPersistenceEntity.positionX = Float(positionComponent?.x ?? 0)
        plotPersistenceEntity.positionY  = Float(positionComponent?.y ?? 0)

        plotPersistenceEntity.soilQuality = soilComponent?.quality ?? 0
        plotPersistenceEntity.soilMoisture = soilComponent?.moisture ?? 0
    }

    private func fetchPersistenceEntity(id: UUID) -> PlotPersistenceEntity? {
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let request = PlotPersistenceEntity.fetchRequest()
        request.predicate = predicate

        return store.fetch(request: request).first
    }
}
