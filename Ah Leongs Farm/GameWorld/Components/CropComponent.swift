//
//  CropComponent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 16/3/25.
//

import GameplayKit

enum CropType: String, Hashable {
    case potato
    case apple
    case bokChoy
}

class CropComponent: GKComponent {
    var cropType: CropType
    var health: Float
    var growth: Float
    var yieldPotential: Float
    var plantedTurn: Int

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
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
