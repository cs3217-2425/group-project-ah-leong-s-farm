//
//  CropViewModel.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 5/4/25.
//

struct CropViewModel {
    let cropType: CropType
    let canHarvest: Bool

    init?(crop: Crop) {
        guard let cropComponent = crop.component(ofType: CropComponent.self),
              let growthComponent = crop.component(ofType: GrowthComponent.self) else {
            return nil
        }

        cropType = cropComponent.cropType
        canHarvest = growthComponent.canHarvest
    }
}
