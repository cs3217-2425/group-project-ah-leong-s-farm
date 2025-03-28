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
