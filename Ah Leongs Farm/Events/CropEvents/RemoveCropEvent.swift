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
        guard let cropSystem = context.getSystem(ofType: CropSystem.self),
              let soundSystem = context.getSystem(ofType: SoundSystem.self),
              let energySystem = context.getSystem(ofType: EnergySystem.self) else {
            return nil
        }

        guard energySystem.getCurrentEnergy(of: .base) > 0 else {
            return InsufficientEnergyErrorEventData(message: "Not enough energy to remove crop!")
        }

        let isSuccessfullyRemoved = cropSystem.removeCrop(row: row, column: column)
        if isSuccessfullyRemoved {
            energySystem.useEnergy(of: .base, amount: 1)
            soundSystem.playSoundEffect(named: "remove-crop")
        }
        
        return RemoveCropEventData(
            row: row,
            column: column,
            isSuccessfullyRemoved: isSuccessfullyRemoved
        )
    }

}
