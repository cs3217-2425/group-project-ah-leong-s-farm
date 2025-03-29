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

    private var entityNodeMap: [ObjectIdentifier: any IRenderNode] = [:]
    private var renderManagerMap: [ObjectIdentifier: any IRenderManager] = [:]
    private var renderPipeline: Queue<any IRenderManager> = Queue()

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
        if gameScene != nil {
            removeAllNodes()
        }

        gameScene = scene
        gameScene?.setGameSceneUpdateDelegate(self)

        guard let gameWorld = gameManager?.gameWorld,
              let gameScene = gameScene else {
            return
        }

        let allEntities = Set(gameWorld.getAllEntities())
        executeRenderPipeline(allEntities: allEntities, in: gameScene)
    }

    func getSKNodes<T: SKNode>(ofType type: T.Type) -> [T] {
        entityNodeMap.filter { _, node in node.managedSKNodeType == type }
            .compactMap { _, node in node.skNode as? T }
    }

    /// Sets up the render managers for the game renderer.
    private func setUpRenderManagers() {
        let renderManagers: [any IRenderManager] = [
            TileMapRenderManager(),
            PlotSpriteRenderManager(uiPositionProvider: self),
            GenericSpriteRenderManager(uiPositionProvider: self)
        ]

        for renderManager in renderManagers {
            renderPipeline.enqueue(renderManager)
            renderManagerMap[ObjectIdentifier(renderManager.renderNodeType)] = renderManager
        }
    }

    private func removeAllNodes() {
        for (_, renderNode) in entityNodeMap {
            renderNode.skNode.removeFromParent()
        }

        entityNodeMap.removeAll()
    }

    private func executeRenderPipeline(allEntities: Set<EntityType>, in scene: GameScene) {
        let entitiesToCreateFor = getEntitiesForCreation(allEntities: allEntities)
        let entityIdentifiersToRemove = getEntitiesForRemoval(allEntities: allEntities)

        for renderManager in renderPipeline.iterable {
            for entity in entitiesToCreateFor {
                guard entityNodeMap[ObjectIdentifier(entity)] == nil else {
                    continue
                }

                if let renderNode = renderManager.createNode(of: entity) {
                    entityNodeMap[ObjectIdentifier(entity)] = renderNode
                    scene.addChild(renderNode.skNode)
                }
            }
        }

        for entityIdentifier in entityIdentifiersToRemove {
            guard let renderNode = entityNodeMap[entityIdentifier] else {
                continue
            }

            renderNode.skNode.removeFromParent()
            entityNodeMap.removeValue(forKey: entityIdentifier)
        }
    }

    private func getEntitiesForCreation(allEntities: Set<EntityType>) -> Set<EntityType> {
        allEntities.filter { entity in
            entityNodeMap[ObjectIdentifier(entity)] == nil
        }
    }

    private func getEntitiesForRemoval(allEntities: Set<EntityType>) -> Set<ObjectIdentifier> {
        let allEntityIdentifiers = allEntities.map { ObjectIdentifier($0) }
        let entityIdentifiersWithRenderNodes = Set(entityNodeMap.keys)
        let entityIdentifiersForRemoval = entityIdentifiersWithRenderNodes.subtracting(allEntityIdentifiers)
        return entityIdentifiersForRemoval
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

        executeRenderPipeline(allEntities: allEntities, in: scene)
    }
}

extension GameRenderer: UIPositionProvider {

    private var skTileMapNode: SKTileMapNode? {
        getSKNodes(ofType: SKTileMapNode.self).first
    }

    func getSelectedRowAndColumn(at touchPosition: CGPoint) -> (Int, Int)? {
        guard let skTileMapNode = skTileMapNode,
              let scene = gameScene else {
            return nil
        }

        // Convert the touch position to the tile map node's coordinate system
        let locationInTileMap = scene.convert(touchPosition, to: skTileMapNode)
        let tileMapPoint = getTileMapPoint(fromPosition: locationInTileMap, tileMapNode: skTileMapNode)

        let rowOneIndexed = skTileMapNode.tileRowIndex(fromPosition: tileMapPoint)
        let columnOneIndexed = skTileMapNode.tileColumnIndex(fromPosition: tileMapPoint)

        let rowZeroIndexed = rowOneIndexed - 1
        let columnZeroIndexed = columnOneIndexed - 1

        guard skTileMapNode.isColumnValid(columnZeroIndexed),
              skTileMapNode.isRowValid(rowZeroIndexed) else {
            return nil
        }

        return (rowZeroIndexed, columnZeroIndexed)
    }

    func getUIPosition(row: Int, column: Int) -> CGPoint? {
        guard let skTileMapNode = skTileMapNode else {
            return nil
        }

        guard skTileMapNode.isRowValid(row), skTileMapNode.isColumnValid(column) else {
            return nil
        }

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
