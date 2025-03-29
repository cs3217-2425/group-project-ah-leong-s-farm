//
//  SKTileMapNode+IRenderNode.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 30/3/25.
//

import SpriteKit

// MARK: - IRenderNode
extension SKTileMapNode: IRenderNode {
    var handler: InteractionHandler? {
        get {
            nil
        }
        set {
            // ignore
        }
    }
}
