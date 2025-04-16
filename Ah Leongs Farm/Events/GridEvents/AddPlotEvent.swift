//
//  AddPlotEvent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 2/4/25.
//

import Foundation

struct AddPlotEvent: GameEvent {
    let row: Int
    let column: Int

    func execute(in context: any EventContext, queueable: any EventQueueable) -> (any EventData)? {
        guard let gridSystem = context.getSystem(ofType: GridSystem.self) else {
            return nil
        }

        let plot = Plot(position: CGPoint(x: row, y: column))

        let isSuccessfullyAdded = gridSystem.addPlot(plot)

        return AddPlotEventData(row: row, column: column, isSuccessfullyAdded: isSuccessfullyAdded)
    }
}
