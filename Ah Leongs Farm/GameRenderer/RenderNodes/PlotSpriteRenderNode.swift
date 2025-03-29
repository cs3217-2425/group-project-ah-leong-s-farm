//
//  PlotSpriteRenderNode.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 29/3/25.
//

import SpriteKit

class PlotSpriteRenderNode: IRenderNode {
    let skNode: PlotSpriteNode

    init(imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        skNode = PlotSpriteNode(texture: texture, color: .clear, size: texture.size())
    }
}
