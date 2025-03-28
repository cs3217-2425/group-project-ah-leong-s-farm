//
//  SKTileMapNodeComponent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/3/25.
//

import GameplayKit

class TileMapRenderNode: IRenderNode {

    let tileMapNode: SKTileMapNode

    var skNode: SKNode {
        tileMapNode
    }

    var rows: Int {
        tileMapNode.numberOfRows
    }

    var columns: Int {
        tileMapNode.numberOfColumns
    }

    init(tileSet: SKTileSet, rows: Int, columns: Int, tileSize: CGSize) {
        tileMapNode = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        tileMapNode.enableAutomapping = false
    }

    func fill(with tileGroupName: String) {
        let tileSet = tileMapNode.tileSet
        guard let tileGroup = tileSet.tileGroups.first(where: { $0.name == tileGroupName }) else {
            return
        }

        tileMapNode.fill(with: tileGroup)
    }

    func isRowValid(_ row: Int) -> Bool {
        row >= 0 && row < rows
    }

    func isColumnValid(_ column: Int) -> Bool {
        column >= 0 && column < columns
    }
}
