//
//  SKTileMapNodeComponent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/3/25.
//

import GameplayKit

class TileMapRenderNode: IRenderNode {

    private let tileMapNode: SKTileMapNode

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

    /// Get selected row and column from touch position
    /// Rows and columns are zero-indexed.
    /// - Parameter touchPosition: Touch position in the scene's coordinate system.
    func getSelectedRowAndColumn(at touchPosition: CGPoint) -> (Int, Int)? {
        guard let scene = tileMapNode.scene else {
            return nil
        }

        // Convert the touch position to the tile map node's coordinate system
        let locationInTileMap = scene.convert(touchPosition, to: tileMapNode)
        let tileMapPoint = getTileMapPoint(fromPosition: locationInTileMap)

        let rowOneIndexed = tileMapNode.tileRowIndex(fromPosition: tileMapPoint)
        let columnOneIndexed = tileMapNode.tileColumnIndex(fromPosition: tileMapPoint)

        let rowZeroIndexed = rowOneIndexed - 1
        let columnZeroIndexed = columnOneIndexed - 1

        let isRowValid = rowZeroIndexed >= 0 && rowZeroIndexed < rows
        let isColumnValid = columnZeroIndexed >= 0 && columnZeroIndexed < columns

        guard isColumnValid, isRowValid else {
            return nil
        }

        return (rowZeroIndexed, columnZeroIndexed)
    }

    private func getTileMapPoint(fromPosition location: CGPoint) -> CGPoint {
        let tileMapPoint = CGPoint(
            x: floor(location.x / tileMapNode.tileSize.width) * tileMapNode.tileSize.width,
            y: floor(location.y / tileMapNode.tileSize.height) * tileMapNode.tileSize.height
        )

        return tileMapPoint
    }
}
