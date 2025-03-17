//
//  SpriteComponent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/3/25.
//

import GameplayKit
import SpriteKit

class SpriteComponent: GKComponent {

    let spriteNode: SKSpriteNode

    required init?(coder: NSCoder) {
        spriteNode = SKSpriteNode()
        super.init(coder: coder)
    }

    init(texture: SKTexture) {
        spriteNode = SKSpriteNode(texture: texture)
        super.init()
    }

    init(node: SKSpriteNode) {
        spriteNode = node
        super.init()
    }
}
