//
//  AnimationManager.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 17/4/25.
//

import SpriteKit

/// Manages animations for various plot actions
class AnimationManager {

    // MARK: - Properties
    private weak var spriteNode: SpriteNode?

    // MARK: - Initialization
    init(spriteNode: SpriteNode?) {
        self.spriteNode = spriteNode
    }

    // MARK: - Animation Methods
    func runWaterAnimation() {
        guard let spriteNode = spriteNode else {
            return
        }

        let referenceSize = spriteNode.size

        let wateringCanSize = CGSize(width: referenceSize.width,
                                     height: referenceSize.height)
        let dropletsSize = CGSize(width: referenceSize.width,
                                  height: referenceSize.height)

        // Create watering can sprite
        let wateringCan = SKSpriteNode(imageNamed: "water_can")
        wateringCan.size = wateringCanSize
        wateringCan.position = CGPoint(x: referenceSize.width * 0.5, y: referenceSize.height * 1.25)
        wateringCan.zPosition = spriteNode.zPosition + 1
        wateringCan.alpha = 0
        spriteNode.addChild(wateringCan)

        // Create water droplets sprite
        let droplets = SKSpriteNode(imageNamed: "water_droplets")
        droplets.size = dropletsSize
        droplets.position = .zero
        droplets.zPosition = wateringCan.zPosition - 1
        droplets.alpha = 0.8
        spriteNode.addChild(droplets)

        // Animate watering can
        let canSequence = SKAction.sequence([
            .fadeIn(withDuration: 0.2),
            .moveBy(x: 0, y: -referenceSize.height * 0.2, duration: 0.3),
            .wait(forDuration: 0.4),
            .moveBy(x: 0, y: referenceSize.height * 0.2, duration: 0.3),
            .fadeOut(withDuration: 0.2),
            .removeFromParent()
        ])
        wateringCan.run(canSequence)

        // Animate droplets
        let drip = SKAction.sequence([
            .wait(forDuration: 0.2 + 0.3), // match fadeIn + moveDown timing
            .fadeOut(withDuration: 0.5),
            .removeFromParent()
        ])
        droplets.run(drip)
    }

    // Additional animation methods can be added here:
    // - runFertilizeAnimation()
    // - runHarvestAnimation()
    // - runPlantAnimation()
    // etc.
}
