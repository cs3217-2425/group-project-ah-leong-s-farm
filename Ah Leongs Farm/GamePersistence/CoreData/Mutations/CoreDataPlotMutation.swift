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
    private let shouldSave: Bool

    init(store: Store, shouldSave: Bool = false) {
        self.store = store
        plotSerializer = PlotSerializer(store: store)
        self.shouldSave = shouldSave
    }

    convenience init?(shouldSave: Bool = false) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }

        self.init(store: appDelegate.persistentContainer, shouldSave: shouldSave)
    }

    func upsertPlot(sessionId: UUID, id: UUID, plot: Plot) -> Bool {
        guard plotSerializer.serialize(sessionId: sessionId, id: id, plot: plot) ??
                plotSerializer.serializeNew(sessionId: sessionId, id: id, plot: plot) != nil else {
            return false
        }

        if shouldSave {
            do {
                try store.managedContext.save()
            } catch {
                store.rollback()
                return false
            }
        }

        return true
    }

    func deletePlot(id: UUID) -> Bool {
        guard let plotPersistenceEntity = fetchPlotById(id: id) else {
            return false
        }

        store.managedContext.delete(plotPersistenceEntity)

        if shouldSave {
            do {
                try store.managedContext.save()
            } catch {
                store.rollback()
                return false
            }
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
