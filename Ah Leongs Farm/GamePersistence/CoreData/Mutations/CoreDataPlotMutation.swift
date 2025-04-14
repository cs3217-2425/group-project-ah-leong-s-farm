//
//  CoreDataPlotMutation.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/4/25.
//

import UIKit

class CoreDataPlotMutation: PlotMutation {
    private let store: Store
    private let plotSerializer: PlotSerializer

    init(store: Store) {
        self.store = store
        plotSerializer = PlotSerializer(store: store)
    }

    convenience init?() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }

        self.init(store: appDelegate.persistentContainer)
    }

    func upsertPlot(id: UUID, plot: Plot) -> Bool {
        _ = plotSerializer.serialize(id: id, plot: plot) ??
            plotSerializer.serializeNew(id: id, plot: plot)

        do {
            try store.save()
        } catch {
            store.rollback()
            return false
        }

        return true
    }

    func deletePlot(id: UUID) -> Bool {
        guard let plotPersistenceEntity = fetchPlotById(id: id) else {
            // No plot found with the given ID
            return true
        }

        store.managedContext.delete(plotPersistenceEntity)

        do {
            try store.save()
        } catch {
            store.rollback()
            return false
        }

        return true
    }

    private func fetchPlotById(id: UUID) -> PlotPersistenceEntity? {
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let request = PlotPersistenceEntity.fetchRequest()
        request.predicate = predicate

        return store.fetch(request: request).first
    }

}
