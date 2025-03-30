import GameplayKit

typealias EntityType = GKEntity

/// The `GameRenderer` class is responsible for rendering the game world.
/// It manages different render managers and coordinates the rendering process
/// for various entities in the game.
class GameRenderer {
    private weak var gameScene: GameScene?

    private var entityNodeMap: [ObjectIdentifier: IRenderNode] = [:]
    private var renderPipeline: Queue<any IRenderManager> = Queue()

    var allRenderNodes: [any IRenderNode] {
        Array(entityNodeMap.values)
    }

    init() {
        setUpRenderPipeline()
    }

    /// Sets the game scene for rendering.
    ///
    /// - Parameter scene: The game scene to be set for rendering.
    func setScene(_ scene: GameScene?) {
        if gameScene != nil {
            removeAllNodes()
        }

        // set the new scene
        gameScene = scene
    }

    private func setUpRenderPipeline() {
        renderPipeline.enqueue(TileMapRenderManager())
        renderPipeline.enqueue(SpriteRenderManager(uiPositionProvider: self))
    }

    private func removeAllNodes() {
        for node in allRenderNodes {
            node.removeFromParent()
        }

        entityNodeMap.removeAll()
    }

    private func executeRenderPipeline(allEntities: Set<EntityType>, in scene: GameScene) {
        let entitiesToCreateFor = getEntitiesForCreation(allEntities: allEntities)
        let entityIdentifiersToRemove = getEntitiesForRemoval(allEntities: allEntities)

        for renderManager in renderPipeline.iterable {
            for entity in entitiesToCreateFor {
                if let node = renderManager.createNode(of: entity) {
                    entityNodeMap[ObjectIdentifier(entity)] = node
                    scene.addChild(node)
                }
            }
        }

        for entityIdentifier in entityIdentifiersToRemove {
            guard let node = entityNodeMap[entityIdentifier] else {
                continue
            }

            node.removeFromParent()
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

extension GameRenderer: IGameObserver {
    func observe(entities: Set<GKEntity>) {
        guard let scene = gameScene else {
            return
        }

        executeRenderPipeline(allEntities: entities, in: scene)
    }
}

extension GameRenderer: UIPositionProvider {

    private var skTileMapNode: SKTileMapNode? {
        allRenderNodes.compactMap({ $0 as? SKTileMapNode }).first
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
