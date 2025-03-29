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

    func createNode(of entity: EntityType) -> SKTileMapNode? {
        guard let gridComponent = entity.component(ofType: GridComponent.self),
              let tileSet = SKTileSet(named: TileMapRenderManager.TileSetName) else {
            return nil
        }

        let tileMapNode = SKTileMapNode(
            tileSet: tileSet,
            columns: gridComponent.numberOfColumns,
            rows: gridComponent.numberOfRows,
            tileSize: TileMapRenderManager.TileSize
        )

        tileMapNode.fill(with: TileMapRenderManager.LandTileGroupName)
        tileMapNode.enableAutomapping = false
        tileMapNode.isUserInteractionEnabled = true

        return tileMapNode
    }
}
