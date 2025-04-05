//
//  RemoveCropEvent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 5/4/25.
//

struct RemoveCropEvent: GameEvent {
    let row: Int
    let column: Int

    func execute(in context: any EventContext, queueable: any EventQueueable) -> (any EventData)? {
        guard let cropSystem = context.getSystem(ofType: CropSystem.self) else {
            return nil
        }

        let isSuccessfullyRemoved = cropSystem.removeCrop(row: row, column: column)

        return RemoveCropEventData(
            row: row,
            column: column,
            isSuccessfullyRemoved: isSuccessfullyRemoved
        )
    }

}
