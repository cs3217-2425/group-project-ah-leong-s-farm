//
//  WaterPlotEvent.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 14/4/25.
//

struct WaterPlotEvent: GameEvent {
    let row: Int
    let column: Int

    func execute(in context: any EventContext, queueable: any EventQueueable) -> (any EventData)? {
        guard let gridSystem = context.getSystem(ofType: GridSystem.self) else {
            return nil
        }

        gridSystem.waterPlot(row: row, column: column)

        return WaterPlotEventData(row: row, column: column, isSuccessfullyWatered: true)
    }
}
