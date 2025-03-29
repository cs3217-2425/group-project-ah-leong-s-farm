import GameplayKit

typealias EntityType = GKEntity

/// The `GameRenderer` class is responsible for rendering the game world.
/// It manages different render managers and coordinates the rendering process
/// for various entities in the game.
///
/// The `GameRenderer` class observes the game state and updates the rendering
/// accordingly. It also provides methods to identify and retrieve render nodes
/// associated with specific entities.
///
/// **Note:** Each render manager must manage a unique type of render node.
class GameRenderer {
    private weak var gameManager: GameManager?
    private weak var gameScene: GameScene?

    private var renderManagerMap: [ObjectIdentifier: any IRenderManager] = [:]

    /// Initializes a new instance of the `GameRenderer` class with the specified game manager.
    ///
    /// - Parameter gameManager: The game manager responsible for managing the game state.
    init(gameManager: GameManager) {
        self.gameManager = gameManager
        self.gameManager?.addGameObserver(self)
        setUpRenderManagers()
    }

    /// Sets the game scene for rendering.
    ///
    /// - Parameter scene: The game scene to be set for rendering.
    func setScene(_ scene: GameScene?) {
        if let previousScene = gameScene {
            for renderManager in renderManagerMap.values {
                renderManager.removeAllNodes(in: previousScene)
            }
        }

        gameScene = scene
        gameScene?.setGameSceneUpdateDelegate(self)

        guard let gameWorld = gameManager?.gameWorld,
              let gameScene = gameScene else {
            return
        }

        let allEntities = Set(gameWorld.getAllEntities())
        for renderManager in renderManagerMap.values {
            renderManager.render(entities: allEntities, in: gameScene)
        }
    }

    /// Identifies entities that have a render node of the specified type.
    ///
    /// - Parameter type: The type of the render node.
    /// - Returns: An array of object identifiers for entities with the specified render node type.
    func identifyEntitiesWithRenderNode<T: IRenderNode>(ofType type: T.Type) -> [ObjectIdentifier] {
        guard let renderManager = renderManagerMap[ObjectIdentifier(type)] else {
            return []
        }

        return renderManager.entityNodeMap.map { $0.key }
    }

    /// Retrieves the render node of the specified type for a given entity.
    ///
    /// - Parameters:
    ///   - type: The type of the render node.
    ///   - entityIdentifier: The identifier of the entity.
    /// - Returns: The render node of the specified type for the given entity, or `nil` if not found.
    func getRenderNode<T: IRenderNode>(ofType type: T.Type, entityIdentifier: ObjectIdentifier) -> T? {
        guard let renderManager = renderManagerMap[ObjectIdentifier(type)] else {
            return nil
        }

        return renderManager.getRenderNode(ofType: type, entityIdentifier: entityIdentifier)
    }

    /// Sets up the render managers for the game renderer.
    private func setUpRenderManagers() {
        let renderManagers: [any IRenderManager] = [
            TileMapRenderManager(),
            SpriteRenderManager(uiPositionProvider: self)
        ]

        for renderManager in renderManagers {
            renderManagerMap[ObjectIdentifier(renderManager.renderNodeType)] = renderManager
        }
    }
}

extension GameRenderer: GameSceneUpdateDelegate {
    func update(_ timeInterval: TimeInterval) {
        gameManager?.update(timeInterval)
    }
}

extension GameRenderer: IGameObserver {
    func observe() {
        guard let gameWorld = gameManager?.gameWorld,
              let scene = gameScene else {
            return
        }

        let allEntities = Set(gameWorld.getAllEntities())
        for renderManager in renderManagerMap.values {
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

        return getRenderNode(ofType: TileMapRenderNode.self, entityIdentifier: entityWithTileMapRenderNode)
    }

    func getSelectedRowAndColumn(at touchPosition: CGPoint) -> (Int, Int)? {
        guard let tileMapRenderNode = tileMapRenderNode,
              let scene = gameScene else {
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
