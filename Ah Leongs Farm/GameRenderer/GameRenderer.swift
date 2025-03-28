import GameplayKit

typealias EntityType = GKEntity

class GameRenderer {
    private let scene: SKScene
    private var renderManagers: [any IRenderManager] = []

    init(scene: SKScene) {
        self.scene = scene
        setUpRenderManagers()
    }

    func identifyEntitiesWithRenderNode<T: IRenderNode>(ofType type: T.Type) -> [ObjectIdentifier] {
        var identifiers: [ObjectIdentifier] = []
        for renderManager in renderManagers where type == renderManager.renderNodeType {
            identifiers += renderManager.entityNodeMap.keys
        }
        return identifiers
    }

    private func setUpRenderManagers() {
        renderManagers.append(TileMapRenderManager())
        renderManagers.append(SpriteRenderManager(uiPositionProvider: self))
    }
}

extension GameRenderer: IGameObserver {
    func notify(_ gameWorld: GameWorld) {
        let allEntities = Set(gameWorld.getAllEntities())
        for renderManager in renderManagers {
            renderManager.render(entities: allEntities, in: scene)
        }
    }
}

extension GameRenderer: UIPositionProvider {

    /// From `TileMapRenderManager, we know that there exists up to one `TileMapRenderNode`
    private var tileMapRenderNode: TileMapRenderNode? {
        guard let entityWithTileMapRenderNode = identifyEntitiesWithRenderNode(
            ofType: TileMapRenderNode.self).first else {
            return nil
        }

        guard let tileMapRenderNode = renderManagers.compactMap({ renderManager in
            renderManager.getRenderNode(ofType: TileMapRenderNode.self,
                                        entityIdentifier: entityWithTileMapRenderNode) }).first else {
            return nil
        }

        return tileMapRenderNode
    }

    func getSelectedRowAndColumn(at touchPosition: CGPoint) -> (Int, Int)? {
        guard let tileMapRenderNode = tileMapRenderNode else {
            return nil
        }

        let skTileMapNode = tileMapRenderNode.tileMapNode

        // Convert the touch position to the tile map node's coordinate system
        let locationInTileMap = scene.convert(touchPosition, to: skTileMapNode)
        let tileMapPoint = getTileMapPoint(fromPosition: locationInTileMap, tileMapNode: skTileMapNode)

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

    func getUIPosition(row: Int, column: Int) -> CGPoint? {
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

    private func getTileMapPoint(fromPosition location: CGPoint, tileMapNode: SKTileMapNode) -> CGPoint {
        let tileMapPoint = CGPoint(
            x: floor(location.x / tileMapNode.tileSize.width) * tileMapNode.tileSize.width,
            y: floor(location.y / tileMapNode.tileSize.height) * tileMapNode.tileSize.height
        )

        return tileMapPoint
    }
}
