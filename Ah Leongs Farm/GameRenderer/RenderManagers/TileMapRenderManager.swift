//
//  SpriteRenderSystem.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/3/25.
//

import GameplayKit

class TileMapRenderManager: IRenderManager {
    private static let TileSetName: String = "Farm Tile Set"
    private static let LandTileGroupName: String = "Land"
    private static let TileSize = CGSize(width: 48, height: 48)

    private(set) var entityNodeMap: [ObjectIdentifier: TileMapRenderNode] = [:]

    private var tileMapRenderNode: TileMapRenderNode? {
        entityNodeMap.values.first
    }

    func createNode(of entity: EntityType, in scene: SKScene) {
        // only one tile map node is allowed to be managed
        guard entityNodeMap.isEmpty else {
            return
        }

        guard let gridComponent = entity.component(ofType: GridComponent.self),
              let tileSet = SKTileSet(named: TileMapRenderManager.TileSetName) else {
            return
        }

        let node = TileMapRenderNode(
            tileSet: tileSet,
            rows: gridComponent.numberOfRows,
            columns: gridComponent.numberOfColumns,
            tileSize: TileMapRenderManager.TileSize
        )

        node.fill(with: TileMapRenderManager.LandTileGroupName)

        scene.addChild(node.skNode)
        entityNodeMap[ObjectIdentifier(entity)] = node
    }

    func removeNode(of entityIdentifier: ObjectIdentifier, in scene: SKScene) {
        guard let node = entityNodeMap[entityIdentifier] else {
            return
        }

        node.skNode.removeFromParent()
        entityNodeMap.removeValue(forKey: entityIdentifier)
    }
}

extension TileMapRenderManager: TileMapDelegate {

    func getSelectedRowAndColumn(at touchPosition: CGPoint) -> (Int, Int)? {
        guard let tileMapRenderNode = tileMapRenderNode else {
            return nil
        }

        let skTileMapNode = tileMapRenderNode.tileMapNode

        guard let scene = skTileMapNode.scene else {
            return nil
        }

        // Convert the touch position to the tile map node's coordinate system
        let locationInTileMap = scene.convert(touchPosition, to: skTileMapNode)
        let tileMapPoint = getTileMapPoint(fromPosition: locationInTileMap, using: tileMapRenderNode)

        let rowOneIndexed = skTileMapNode.tileRowIndex(fromPosition: tileMapPoint)
        let columnOneIndexed = skTileMapNode.tileColumnIndex(fromPosition: tileMapPoint)

        let rowZeroIndexed = rowOneIndexed - 1
        let columnZeroIndexed = columnOneIndexed - 1

        guard tileMapRenderNode.isColumnValid(columnZeroIndexed),
              tileMapRenderNode.isRowValid(rowZeroIndexed) else {
            return nil
        }

        return (rowZeroIndexed, columnZeroIndexed)
    }

    func getPosition(row: Int, column: Int) -> CGPoint? {
        guard let tileMapRenderNode = tileMapRenderNode else {
            return nil
        }

        guard tileMapRenderNode.isRowValid(row), tileMapRenderNode.isColumnValid(column) else {
            return nil
        }

        let skTileMapNode = tileMapRenderNode.tileMapNode
        let tileSize = skTileMapNode.tileSize

        // TODO: Investigate why deduction of half the tile size is needed
        let xPosition = CGFloat(column) * tileSize.width + tileSize.width / 2
            - skTileMapNode.mapSize.width / 2
        let yPosition = CGFloat(row) * tileSize.height + tileSize.height / 2
            - skTileMapNode.mapSize.height / 2

        return CGPoint(x: xPosition, y: yPosition)
    }

    private func getTileMapPoint(fromPosition location: CGPoint,
                                 using tileMapRenderNode: TileMapRenderNode) -> CGPoint {
        let tileSize = tileMapRenderNode.tileMapNode.tileSize

        let tileMapPoint = CGPoint(
            x: floor(location.x / tileSize.width) * tileSize.width,
            y: floor(location.y / tileSize.height) * tileSize.height
        )

        return tileMapPoint
    }
}
