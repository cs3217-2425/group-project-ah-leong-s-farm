//
//  CropComponent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 16/3/25.
//

import GameplayKit

enum CropType {
    case potato, none
}

class CropComponent: GKComponent {
    var cropType: CropType
    var health: Float
    var growth: Float
    var yieldPotential: Float
    var plantedTurn: Int

    required init?(coder: NSCoder) {
        health = 0
        growth = 0
        yieldPotential = 0
        plantedTurn = 0
        cropType = .none
        super.init(coder: coder)
    }

    init(cropType: CropType, health: Float, growth: Float, yieldPotential: Float, plantedTurn: Int) {
        self.cropType = cropType
        self.health = health
        self.growth = growth
        self.yieldPotential = yieldPotential
        self.plantedTurn = plantedTurn
        super.init()
    }

}
