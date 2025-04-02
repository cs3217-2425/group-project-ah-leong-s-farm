//
//  SpriteRenderSystem.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/3/25.
//

import GameplayKit

class TileMapRenderManager: IRenderManager {
    /// hard-coded from `FarmTileSet.sks`
    static let TileSize = CGSize(width: 80, height: 80)

    private static let TileSetName: String = "Farm Tile Set"
    private static let LandTileGroupName: String = "Land"

    func createNode(for entity: EntityType, in renderer: GameRenderer) {
        guard let gridComponent = entity.component(ofType: GridComponent.self),
              let tileSet = SKTileSet(named: TileMapRenderManager.TileSetName) else {
            return
        }

        let tileMapNode = TileMapNode(
            tileSet: tileSet,
            columns: gridComponent.numberOfColumns,
            rows: gridComponent.numberOfRows,
            tileSize: TileMapRenderManager.TileSize
        )

        tileMapNode.fill(with: TileMapRenderManager.LandTileGroupName)
        tileMapNode.enableAutomapping = false
        tileMapNode.isUserInteractionEnabled = false

        renderer.setRenderNode(for: ObjectIdentifier(entity), node: tileMapNode)
    }
}
