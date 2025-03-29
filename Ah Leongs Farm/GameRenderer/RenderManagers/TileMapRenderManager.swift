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

    func createNode(of entity: EntityType) -> TileMapRenderNode? {
        guard let gridComponent = entity.component(ofType: GridComponent.self),
              let tileSet = SKTileSet(named: TileMapRenderManager.TileSetName) else {
            return nil
        }

        let node = TileMapRenderNode(
            tileSet: tileSet,
            rows: gridComponent.numberOfRows,
            columns: gridComponent.numberOfColumns,
            tileSize: TileMapRenderManager.TileSize
        )

        node.fill(with: TileMapRenderManager.LandTileGroupName)
        return node
    }
}
