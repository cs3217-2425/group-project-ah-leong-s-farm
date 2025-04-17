//
//  CropViewModel.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 5/4/25.
//

struct CropViewModel: PlotOccupantViewModel {
    let cropType: CropType
    let canHarvest: Bool
    let currentGrowthTurn: Float
    let totalGrowthTurns: Int
    let currentHealth: Double

    init?(crop: Crop) {
        guard let cropComponent = crop.getComponentByType(ofType: CropComponent.self),
              let growthComponent = crop.getComponentByType(ofType: GrowthComponent.self),
              let healthComponent = crop.getComponentByType(ofType: HealthComponent.self)
        else {
            return nil
        }

        cropType = cropComponent.cropType
        canHarvest = growthComponent.canHarvest
        currentGrowthTurn = growthComponent.currentGrowthTurn
        totalGrowthTurns = growthComponent.totalGrowthTurns
        currentHealth = healthComponent.health
    }
}
