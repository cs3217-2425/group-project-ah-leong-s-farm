//
//  BokChoyPersistenceEntity+CropDeserializable.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 19/4/25.
//

import Foundation

extension BokChoyPersistenceEntity: CropDeserializable {
    func deserialize() -> Crop {
        let health = healthComponent?.health ?? 0
        let isHarvested = harvestedComponent != nil
        let isItem = itemComponent != nil

        var position: CGPoint? = nil
        var growthConfig: GrowthConfig? = nil

        if let positionComponent = positionComponent {
            position = CGPoint(x: CGFloat(positionComponent.x), y: CGFloat(positionComponent.y))
        }

        if let growthComponent = growthComponent {
            growthConfig = GrowthConfig(
                totalGrowthTurns: Int(growthComponent.totalGrowthTurns),
                currentGrowthTurn: growthComponent.currentGrowthTurn
            )
        }

        guard let persistenceID = id else {
            let newPersistenceID = UUID()
            id = newPersistenceID

            let config = CropConfig(
                persistenceID: newPersistenceID,
                health: health,
                position: position,
                growthConfig: growthConfig,
                isHarvested: isHarvested,
                isItem: isItem
            )

            return BokChoy(config: config)
        }

        let config = CropConfig(
            persistenceID: persistenceID,
            health: health,
            position: position,
            growthConfig: growthConfig,
            isHarvested: isHarvested,
            isItem: isItem
        )

        return BokChoy(config: config)
    }
}
