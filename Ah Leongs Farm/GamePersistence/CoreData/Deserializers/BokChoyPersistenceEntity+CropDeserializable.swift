//
//  BokChoyPersistenceEntity+CropDeserializable.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 19/4/25.
//

import Foundation

extension BokChoyPersistenceEntity: CropDeserializable {
    func deserialize() -> Crop {
        let isHarvested = harvestedComponent != nil
        let isItem = itemComponent != nil
        let healthConfig = HealthConfig(
            health: healthComponent?.health ?? 0,
            maxHealth: healthComponent?.maxHealth ?? 0
        )
        let yieldConfig = YieldConfig(
            yield: Int(yieldComponent?.yield ?? 0),
            maxYield: Int(yieldComponent?.maxYield ?? 0)
        )

        var position: CGPoint?
        var growthConfig: GrowthConfig?

        if let positionComponent = positionComponent {
            position = CGPoint(x: CGFloat(positionComponent.x), y: CGFloat(positionComponent.y))
        }

        if let growthComponent = growthComponent {
            growthConfig = GrowthConfig(
                totalGrowthTurns: Int(growthComponent.totalGrowthTurns),
                currentGrowthTurn: growthComponent.currentGrowthTurn,
                totalGrowthStages: Int(growthComponent.totalGrowthStages)
            )
        }

        guard let persistenceID = id else {
            let newPersistenceID = UUID()
            id = newPersistenceID

            let config = CropConfig(
                persistenceID: newPersistenceID,
                healthConfig: healthConfig,
                yieldConfig: yieldConfig,
                position: position,
                growthConfig: growthConfig,
                isHarvested: isHarvested,
                isItem: isItem
            )

            return BokChoy(config: config)
        }

        let config = CropConfig(
            persistenceID: persistenceID,
            healthConfig: healthConfig,
            yieldConfig: yieldConfig,
            position: position,
            growthConfig: growthConfig,
            isHarvested: isHarvested,
            isItem: isItem
        )

        return BokChoy(config: config)
    }
}
