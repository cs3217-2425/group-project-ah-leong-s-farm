//
//  PotatoSpriteNode.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 2/4/25.
//

import SpriteKit

final class PotatoSpriteNode: SpriteNode {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handler?.handleInteraction(node: self)
    }
}
