//
//  BokChoySpriteNode.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 2/4/25.
//

import SpriteKit

final class BokChoySpriteNode: SpriteNode {
    private(set) weak var handler: BokChoySpriteNodeTouchHandler?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handler?.handleTouch(node: self)
    }

    func setHandler(_ handler: BokChoySpriteNodeTouchHandler) {
        self.handler = handler
    }

    override func visitTouchHandlerRegistry(registry: any TouchHandlerRegistry) {
        registry.setTouchHandler(for: self)
    }
}

protocol BokChoySpriteNodeTouchHandler: AnyObject {
    func handleTouch(node: BokChoySpriteNode)
}
