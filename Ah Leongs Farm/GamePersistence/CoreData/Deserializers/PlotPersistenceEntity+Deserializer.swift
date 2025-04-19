//
//  PlotPersistenceEntity+Deserializer.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/4/25.
//

import Foundation

extension PlotPersistenceEntity {
    func deserialize() -> Plot {
        let position = CGPoint(x: CGFloat(positionComponent?.x ?? 0), y: CGFloat(positionComponent?.y ?? 0))
        let soilQuality = soilComponent?.quality ?? 0
        let soilHasWater = soilComponent?.hasWater ?? false

        guard let persistenceID = id else {
            let newPersistenceID = UUID()
            id = newPersistenceID

            return Plot(
                position: position,
                soilQuality: soilQuality,
                soilHasWater: soilHasWater,
                persistenceID: newPersistenceID,
                plotOccupant: nil
            )
        }

        return Plot(
            position: position,
            soilQuality: soilQuality,
            soilHasWater: soilHasWater,
            persistenceID: persistenceID,
            plotOccupant: nil
        )
    }
}
