//
//  AbstractPlotPersistenceManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/4/25.
//

import Foundation

protocol AbstractPlotPersistenceManager {
    var sessionId: UUID { get }
    var plotQuery: PlotQuery? { get }
    var plotMutation: PlotMutation? { get }
}

extension AbstractPlotPersistenceManager {
    func loadPlots() -> [Plot] {
        plotQuery?.fetch(sessionId: sessionId) ?? []
    }

    func save(plot: Plot, persistenceId: UUID) -> Bool {
        guard let plotMutation = plotMutation else {
            return false
        }

        let isSuccessfullyMutated = plotMutation.upsertPlot(sessionId: sessionId, id: persistenceId, plot: plot)

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
