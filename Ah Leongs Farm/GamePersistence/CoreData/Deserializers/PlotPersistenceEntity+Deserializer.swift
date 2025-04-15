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
        let soilMoisture = soilComponent?.moisture ?? 0

        guard let persistenceID = id else {
            let newPersistenceID = UUID()
            id = newPersistenceID

            return Plot(
                position: position,
                soilQuality: soilQuality,
                soilMoisture: soilMoisture,
                persistenceID: newPersistenceID,
                crop: nil
            )
        }

        return Plot(
            position: position,
            soilQuality: soilQuality,
            soilMoisture: soilMoisture,
            persistenceID: persistenceID,
            crop: nil
        )
    }
}
