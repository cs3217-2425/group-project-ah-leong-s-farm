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

<<<<<<< Updated upstream
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
=======
    func createNode(of entity: EntityType) -> IRenderNode? {
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

    func updateNode(for node: inout IRenderNode, using entity: EntityType) {
        // TODO: Implement resizing of tilemap when grid component is resized
    }

>>>>>>> Stashed changes
}
