//
//  SKTileMapNode+IRenderNode.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 30/3/25.
//

import SpriteKit

extension SKTileMapNode: IRenderNode {
    func visitTouchHandlerRegistry(registry: any TouchHandlerRegistry) {
        // ignore
    }
}
