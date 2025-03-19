//
//  PlotEntity.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/3/25.
//

import GameplayKit

class Plot: GKEntity {
    private static let DirtImageName: String = "dirt"
    private static let DefaultSoilQuality: Float = 0
    private static let DefaultSoilMoisture: Float = 0

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(position: CGPoint) {
        super.init()
        setUpComponents(position: position)
    }

    func setUpComponents(position: CGPoint) {
        addComponent(PositionComponent(x: position.x, y: position.y))
        addComponent(SoilComponent(quality: Plot.DefaultSoilQuality, moisture: Plot.DefaultSoilMoisture))

        let dirtTexture = SKTexture(imageNamed: Plot.DirtImageName)
        addComponent(SpriteComponent(texture: dirtTexture))
    }
}
