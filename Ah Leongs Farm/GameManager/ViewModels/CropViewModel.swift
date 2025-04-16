//
//  CropViewModel.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 5/4/25.
//

struct CropViewModel: PlotOccupantViewModel {
    let cropType: CropType
    let canHarvest: Bool
    let currentGrowthTurn: Int
    let totalGrowthTurns: Int

    init?(crop: Crop) {
        guard let cropComponent = crop.getComponentByType(ofType: CropComponent.self),
              let growthComponent = crop.getComponentByType(ofType: GrowthComponent.self)
        else {
            return nil
        }

        self.cropType = cropComponent.cropType
        self.canHarvest = growthComponent.canHarvest
        self.currentGrowthTurn = growthComponent.currentGrowthTurn
        self.totalGrowthTurns = growthComponent.totalGrowthTurns
    }
}
