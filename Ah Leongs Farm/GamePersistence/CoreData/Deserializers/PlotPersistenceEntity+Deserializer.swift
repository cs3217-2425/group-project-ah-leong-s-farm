//
//  PlotPersistenceEntity+Deserializer.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/4/25.
//

import Foundation

extension PlotPersistenceEntity {
    func deserialize() -> Plot {
        let position = CGPoint(x: CGFloat(positionX), y: CGFloat(positionY))
        let persistenceID = id ?? UUID()

        return Plot(
            position: position,
            soilQuality: soilQuality,
            soilMoisture: soilMoisture,
            persistenceID: persistenceID,
            crop: nil
        )
    }
}
