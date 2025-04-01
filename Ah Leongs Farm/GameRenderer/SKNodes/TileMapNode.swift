//
//  TileMapNode.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 1/4/25.
//

import SpriteKit

class TileMapNode: SKTileMapNode, IRenderNode {

    private var lightUpNodes: [SKSpriteNode] = []

    var handler: InteractionHandler? {
        get {
            nil
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // ignore
        }
    }

    func isRowValid(_ row: Int) -> Bool {
        row >= 0 && row < numberOfRows
    }

    func isColumnValid(_ column: Int) -> Bool {
        column >= 0 && column < numberOfColumns
    }

    func fill(with tileGroupName: String) {
        guard let tileGroup = tileSet.tileGroups.first(where: { $0.name == tileGroupName }) else {
            return
        }

        fill(with: tileGroup)
    }

    func lightUpTile(atRow row: Int, column: Int, color: UIColor, blendFactor: CGFloat) {
        guard isRowValid(row), isColumnValid(column) else {
            return
        }

        let tileSize = tileSize
        let tilePosition = centerOfTile(atColumn: column, row: row)
        let colorNode = SKSpriteNode(color: color, size: tileSize)
        colorNode.colorBlendFactor = blendFactor
        colorNode.position = tilePosition
        colorNode.zPosition = 1 // Ensure the color node is above the tile

        lightUpNodes.append(colorNode)
        addChild(colorNode)
    }

    func removeAllLightUpTiles() {
        for node in lightUpNodes {
            node.removeFromParent()
        }
        lightUpNodes.removeAll()
    }
}
