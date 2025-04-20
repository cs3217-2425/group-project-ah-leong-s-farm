//
//  CropConfig.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 19/4/25.
//

import Foundation

struct CropConfig {
    let persistenceID: UUID
    let healthConfig: HealthConfig
    let yieldConfig: YieldConfig
    let position: CGPoint?
    let growthConfig: GrowthConfig?
    let isHarvested: Bool
    let isItem: Bool
}

struct GrowthConfig {
    let totalGrowthTurns: Int
    let currentGrowthTurn: Float
    let totalGrowthStages: Int
}

struct HealthConfig {
    let health: Double
    let maxHealth: Double
}

struct YieldConfig {
    let yield: Int
    let maxYield: Int
}
