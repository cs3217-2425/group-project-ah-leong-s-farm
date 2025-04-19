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
    let position: CGPoint?
    let growthConfig: GrowthConfig?
    let isHarvested: Bool
    let isItem: Bool
}

struct GrowthConfig {
    let totalGrowthTurns: Int
    let currentGrowthTurn: Float
}

struct HealthConfig {
    let health: Double
    let maxHealth: Double
}
