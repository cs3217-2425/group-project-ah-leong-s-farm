//
//  Cabbage.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 16/3/25.
//

import GameplayKit

class Crop: GKEntity {
    private static let DefaultHealth: Float = 100
    private static let DefaultGrowth: Float = 1
    private static let DefaultYieldPotential: Float = 1
    private static let DefaultPlantedTurn: Int = 1

    private static let CropTextureMap: [CropType: SKTexture] = [
        .potato: SKTexture(imageNamed: "potato")
    ]

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(ofType cropType: CropType, position: CGPoint) {
        super.init()
        setUpComponents(cropType: cropType, position: position)
    }

    private func setUpComponents(cropType: CropType, position: CGPoint) {
        guard let spriteTexture = Crop.CropTextureMap[cropType] else {
            return
        }

        addComponent(PositionComponent(x: position.x, y: position.y))
        addComponent(
            CropComponent(
                cropType: cropType,
                health: Crop.DefaultHealth,
                growth: Crop.DefaultGrowth,
                yieldPotential: Crop.DefaultYieldPotential,
                plantedTurn: Crop.DefaultPlantedTurn
            )
        )
        addComponent(SpriteComponent(texture: spriteTexture))
    }
}
