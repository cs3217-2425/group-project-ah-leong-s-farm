//
//  RazePlotEvent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 4/4/25.
//

struct RazePlotEvent: GameEvent {
    let row: Int
    let column: Int

    func execute(in context: any EventContext, queueable: any EventQueueable) -> (any EventData)? {
        guard let gridSystem = context.getSystem(ofType: GridSystem.self) else {
            return nil
        }

        let isSuccessfullyRazed = gridSystem.razePlot(row: row, column: column)

        return RazePlotEventData(row: row, column: column, isSuccessfullyRazed: isSuccessfullyRazed)
    }
}
