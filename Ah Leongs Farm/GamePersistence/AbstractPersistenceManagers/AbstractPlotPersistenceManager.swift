//
//  AbstractPlotPersistenceManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/4/25.
//

import Foundation

protocol AbstractPlotPersistenceManager{
    var plotMutation: PlotMutation? { get }
}

extension AbstractPlotPersistenceManager {
    func save(plot: Plot, persistenceId: UUID) -> Bool {
        guard let plotMutation = plotMutation else {
            return false
        }

        let isSuccessfullyMutated = plotMutation.upsertPlot(id: persistenceId, plot: plot)

        return isSuccessfullyMutated
    }

    func delete(plot: Plot, persistenceId: UUID) -> Bool {
        guard let plotMutation = plotMutation else {
            return false
        }

        let isSuccessfullyDeleted = plotMutation.deletePlot(id: persistenceId)

        return isSuccessfullyDeleted
    }
}
