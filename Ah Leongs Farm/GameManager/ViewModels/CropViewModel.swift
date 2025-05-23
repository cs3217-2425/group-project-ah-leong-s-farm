//
//  CropViewModel.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 5/4/25.
//

struct CropViewModel: PlotOccupantViewModel {
    let canHarvest: Bool
    let currentGrowthTurn: Float
    let totalGrowthTurns: Int
    let currentHealth: Double
    let currentYield: Int
    let maxYield: Int

    init?(crop: Crop) {
        guard crop.getComponentByType(ofType: CropComponent.self) != nil,
              let growthComponent = crop.getComponentByType(ofType: GrowthComponent.self),
              let healthComponent = crop.getComponentByType(ofType: HealthComponent.self),
              let yieldComponent = crop.getComponentByType(ofType: YieldComponent.self)
        else {
            return nil
        }

        canHarvest = growthComponent.canHarvest
        currentGrowthTurn = growthComponent.currentGrowthTurn
        totalGrowthTurns = growthComponent.totalGrowthTurns
        currentHealth = healthComponent.health
        currentYield = yieldComponent.yield
        maxYield = yieldComponent.maxYield
    }
}
