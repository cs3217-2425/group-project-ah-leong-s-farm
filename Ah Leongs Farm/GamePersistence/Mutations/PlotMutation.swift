//
//  PlotMutation.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/4/25.
//

import Foundation

/// A protocol that defines the mutation operations for plots in the game.
protocol PlotMutation {

    func upsertPlot(sessionId: UUID, id: UUID, plot: Plot) -> Bool

    func deletePlot(id: UUID) -> Bool
}
