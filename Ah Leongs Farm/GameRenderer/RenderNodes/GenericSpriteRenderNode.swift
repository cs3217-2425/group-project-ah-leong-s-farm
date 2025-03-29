//
//  SpriteNode.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 27/3/25.
//

import SpriteKit

class GenericSpriteRenderNode: IRenderNode {
    let skNode: SKSpriteNode

    init(spriteNode: SKSpriteNode) {
        self.skNode = spriteNode
    }

    init(imageNamed: String) {
        skNode = SKSpriteNode(imageNamed: imageNamed)
    }
}
