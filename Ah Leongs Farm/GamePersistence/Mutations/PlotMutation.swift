//
//  PlotMutation.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/4/25.
//

import Foundation

/// A protocol that defines the mutation operations for plots in the game.
protocol PlotMutation {

    /// Updates the plot, if any, with the given ID. If the plot does not exist, it will be created.
    /// - Parameters:
    ///   - id: The UUID of the plot to update.
    ///   - plot: The updated plot object.
    ///   - Returns: A boolean indicating whether the update was successful.
    func upsertPlot(id: UUID, plot: Plot) -> Bool

    func deletePlot(id: UUID) -> Bool
}
