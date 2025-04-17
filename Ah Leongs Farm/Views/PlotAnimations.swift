//
//  PlotAnimations.swift
//  Ah Leongs Farm
//
//  Created by proglab on 18/4/25.
//
import UIKit
import SpriteKit

class PlotAnimations {
   func runWaterAnimation(on spriteNode: SKSpriteNode?) {
        guard let spriteNode = spriteNode else {
            return
        }

        let referenceSize = spriteNode.size

        let wateringCanSize = CGSize(width: referenceSize.width,
                                     height: referenceSize.height)
        let dropletsSize = CGSize(width: referenceSize.width,
                                  height: referenceSize.height)

        // Watering can
        let wateringCan = SKSpriteNode(imageNamed: "water_can")
        wateringCan.size = wateringCanSize
        wateringCan.position = CGPoint(x: referenceSize.width * 0.5, y: referenceSize.height * 1.25)
        wateringCan.zPosition = spriteNode.zPosition + 1
        wateringCan.alpha = 0
        spriteNode.addChild(wateringCan)

        // Droplets
        let droplets = SKSpriteNode(imageNamed: "water_droplets")
        droplets.size = dropletsSize
        droplets.position = .zero
        droplets.zPosition = wateringCan.zPosition - 1
        droplets.alpha = 0.8
        spriteNode.addChild(droplets)

        // Can animation
        let canSequence = SKAction.sequence([
            .fadeIn(withDuration: 0.2),
            .moveBy(x: 0, y: -referenceSize.height * 0.2, duration: 0.3),
            .wait(forDuration: 0.4),
            .moveBy(x: 0, y: referenceSize.height * 0.2, duration: 0.3),
            .fadeOut(withDuration: 0.2),
            .removeFromParent()
        ])
        wateringCan.run(canSequence)

        // Droplets animation
        let drip = SKAction.sequence([
            .wait(forDuration: 0.2 + 0.3), // match fadeIn + moveDown timing
            .fadeOut(withDuration: 0.5),
            .removeFromParent()
        ])
        droplets.run(drip)
    }
}
