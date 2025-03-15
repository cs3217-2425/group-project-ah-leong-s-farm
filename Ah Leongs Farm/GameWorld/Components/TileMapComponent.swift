//
//  SKTileMapNodeComponent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/3/25.
//

import GameplayKit
import SpriteKit

class TileMapComponent: GKComponent {

    let tileMapNode: SKTileMapNode

    var rows: Int {
        tileMapNode.numberOfRows
    }

    var columns: Int {
        tileMapNode.numberOfColumns
    }

    required init?(coder: NSCoder) {
        tileMapNode = SKTileMapNode()
        super.init(coder: coder)
        tileMapNode.enableAutomapping = false
    }

    init(tileSet: SKTileSet, rows: Int, columns: Int, tileSize: CGSize) {
        tileMapNode = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        super.init()
        tileMapNode.enableAutomapping = false
    }

    func fill(with tileGroupName: String) {
        let tileSet = tileMapNode.tileSet
        guard let tileGroup = tileSet.tileGroups.first(where: { $0.name == tileGroupName }) else {
            return
        }

        tileMapNode.fill(with: tileGroup)
    }
}
