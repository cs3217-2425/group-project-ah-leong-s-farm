//
//  SKTileMapNodeComponent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/3/25.
//

import GameplayKit

class TileMapRenderNode: IRenderNode {

    let skNode: SKTileMapNode

    init(tileSet: SKTileSet, rows: Int, columns: Int, tileSize: CGSize) {
        skNode = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        skNode.enableAutomapping = false
        skNode.isUserInteractionEnabled = true
    }

    func fill(with tileGroupName: String) {
        let tileSet = skNode.tileSet
        guard let tileGroup = tileSet.tileGroups.first(where: { $0.name == tileGroupName }) else {
            return
        }

        skNode.fill(with: tileGroup)
    }
}
