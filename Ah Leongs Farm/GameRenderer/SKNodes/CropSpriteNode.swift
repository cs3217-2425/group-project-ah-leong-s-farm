//
//  CropSpriteNode.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 4/4/25.
//

import SpriteKit

class CropSpriteNode: SpriteNode {
    private(set) weak var handler: CropSpriteNodeTouchHandler?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handler?.handleTouch(node: self)
    }

    func setHandler(_ handler: CropSpriteNodeTouchHandler) {
        self.handler = handler
    }

    override func visitTouchHandlerRegistry(registry: any TouchHandlerRegistry) {
        registry.setTouchHandler(for: self)
    }
}

protocol CropSpriteNodeTouchHandler: AnyObject {
    func handleTouch(node: CropSpriteNode)
}
