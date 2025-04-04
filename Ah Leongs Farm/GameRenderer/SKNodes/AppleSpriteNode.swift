//
//  AppleSpriteNode.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 2/4/25.
//

import SpriteKit

final class AppleSpriteNode: SpriteNode {
    private(set) weak var handler: AppleSpriteNodeTouchHandler?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handler?.handleTouch(node: self)
    }

    func setHandler(_ handler: AppleSpriteNodeTouchHandler) {
        self.handler = handler
    }

    override func visitTouchHandlerRegistry(registry: any TouchHandlerRegistry) {
        registry.setTouchHandler(for: self)
    }
}

protocol AppleSpriteNodeTouchHandler: AnyObject {
    func handleTouch(node: AppleSpriteNode)
}
