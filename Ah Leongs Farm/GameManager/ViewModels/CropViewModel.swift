//
//  CropViewModel.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 5/4/25.
//

struct CropViewModel {
    let cropType: CropType
    let canHarvest: Bool
    let currentGrowthTurn: Int
    let totalGrowthTurns: Int

    init?(crop: Crop) {
        guard let cropComponent = crop.getComponentByType(ofType: CropComponent.self),
              let growthComponent = crop.getComponentByType(ofType: GrowthComponent.self) else {
            return nil
        }

        cropType = cropComponent.cropType
        canHarvest = growthComponent.canHarvest
        currentGrowthTurn = growthComponent.currentGrowthTurn
        totalGrowthTurns = growthComponent.totalGrowthTurns
    }
}
