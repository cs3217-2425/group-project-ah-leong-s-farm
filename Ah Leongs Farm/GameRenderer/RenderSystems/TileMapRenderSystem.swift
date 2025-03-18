//
//  SpriteRenderSystem.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/3/25.
//

import GameplayKit

class TileMapRenderSystem: IRenderSystem {
    private static let TileSetName: String = "Farm Tile Set"
    private static let LandTileGroupName: String = "Land"
    private static let TileSize: CGSize = CGSize(width: 48, height: 48)

    func createNode(of entity: EntityType) -> IRenderNode? {
        guard let gridComponent = entity.component(ofType: GridComponent.self),
              let tileSet = SKTileSet(named: TileMapRenderSystem.TileSetName) else {
            return nil
        }

        let node = TileMapRenderNode(
            tileSet: tileSet,
            rows: gridComponent.numberOfRows,
            columns: gridComponent.numberOfColumns,
            tileSize: TileMapRenderSystem.TileSize
        )

        node.fill(with: TileMapRenderSystem.LandTileGroupName)

        return node
    }
}
