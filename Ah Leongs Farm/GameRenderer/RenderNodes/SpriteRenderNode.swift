//
//  SpriteNode.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 27/3/25.
//

import SpriteKit

class SpriteRenderNode: IRenderNode {
    private let spriteNode: SKSpriteNode

    var skNode: SKNode {
        spriteNode
    }

    init(imageNamed: String) {
        spriteNode = SKSpriteNode(imageNamed: imageNamed)
    }
}
