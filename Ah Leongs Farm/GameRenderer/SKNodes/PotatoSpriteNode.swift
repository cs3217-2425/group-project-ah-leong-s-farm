//
//  PotatoSpriteNode.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 2/4/25.
//

import SpriteKit

final class PotatoSpriteNode: SpriteNode {
    private(set) weak var handler: PotatoSpriteNodeTouchHandler?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handler?.handleTouch(node: self)
    }

    func setHandler(_ handler: PotatoSpriteNodeTouchHandler) {
        self.handler = handler
    }

    override func visitTouchHandlerRegistry(registry: any TouchHandlerRegistry) {
        registry.setTouchHandler(for: self)
    }
}

protocol PotatoSpriteNodeTouchHandler: AnyObject {
    func handleTouch(node: PotatoSpriteNode)
}
