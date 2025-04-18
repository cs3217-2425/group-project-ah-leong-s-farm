//
//  IRenderNode.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 30/3/25.
//

import SpriteKit

protocol IRenderNode: AnyObject {
    func visitTouchHandlerRegistry(registry: TouchHandlerRegistry)
    func updateTexture(image: String)
    func getSKNode() -> SKNode
}
