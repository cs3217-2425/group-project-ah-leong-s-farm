import GameplayKit

typealias EntityType = GKEntity

/// The `GameRenderer` class is responsible for rendering the game world.
/// It manages different render managers and coordinates the rendering process
/// for various entities in the game.
class GameRenderer {
    private weak var gameScene: GameScene?
    private var renderPipeline: Queue<any IRenderManager> = Queue()

    private var entityTileMapNodeMap: [ObjectIdentifier: TileMapNode] = [:]
    private var entitySpriteNodeMap: [ObjectIdentifier: SpriteNode] = [:]
    private var entityNodeMap: [ObjectIdentifier: any IRenderNode] {
        let maps: [[ObjectIdentifier: any IRenderNode]] = [entityTileMapNodeMap, entitySpriteNodeMap]
        return maps.reduce(into: [:]) { $0.merge($1) { _, new in new } }
    }

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
            removeAllRenderNodes()
        }

        // set the new scene
        gameScene = scene
    }

    func setRenderNode(for entityIdentifier: ObjectIdentifier, node: TileMapNode) {
        let shouldAddToScene = entityTileMapNodeMap[entityIdentifier] == nil

        entityTileMapNodeMap[entityIdentifier] = node

        if shouldAddToScene {
            gameScene?.addChild(node)
        }
    }

    func setRenderNode(for entityIdentifier: ObjectIdentifier, node: SpriteNode) {
        let shouldAddToScene = entitySpriteNodeMap[entityIdentifier] == nil

        entitySpriteNodeMap[entityIdentifier] = node

        if shouldAddToScene {
            gameScene?.addChild(node)
        }
    }

    func lightUpTile(at row: Int, column: Int) {
        guard let tileMapNode = tileMapNode else {
            return
        }

        tileMapNode.lightUpTile(atRow: row, column: column, color: .white, blendFactor: 0.5)
    }

    func unlightAllTiles() {
        tileMapNode?.removeAllLightUpTiles()
    }

    private func removeRenderNode(for entityIdentifier: ObjectIdentifier) {
        if let node = entityTileMapNodeMap[entityIdentifier] {
            node.removeFromParent()
            entityTileMapNodeMap.removeValue(forKey: entityIdentifier)
        } else if let node = entitySpriteNodeMap[entityIdentifier] {
            node.removeFromParent()
            entitySpriteNodeMap.removeValue(forKey: entityIdentifier)
        }
    }

    private func removeAllRenderNodes() {
        for entityIdentifier in entityNodeMap.keys {
            removeRenderNode(for: entityIdentifier)
        }
    }

    private func setUpRenderPipeline() {
        renderPipeline.enqueue(TileMapRenderManager())
        renderPipeline.enqueue(SpriteRenderManager(uiPositionProvider: self))
    }

    private func executeRenderPipeline(allEntities: Set<EntityType>, in scene: GameScene) {
        let entitiesToCreateFor = getEntitiesForCreation(allEntities: allEntities)
        let entityIdentifiersToRemove = getEntitiesForRemoval(allEntities: allEntities)

        for renderManager in renderPipeline.iterable {
            for entity in entitiesToCreateFor {
                renderManager.createNode(for: entity, in: self)
            }
        }

        for entityIdentifier in entityIdentifiersToRemove {
            removeRenderNode(for: entityIdentifier)
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

    private var tileMapNode: TileMapNode? {
        entityTileMapNodeMap.values.first
    }

    func getUIPosition(row: Int, column: Int) -> CGPoint? {
        guard let skTileMapNode = tileMapNode else {
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

    func getRowAndColumn(fromPosition location: CGPoint) -> (row: Int, column: Int)? {
        guard let tileMapNode = tileMapNode else {
            return nil
        }

        let tileMapPoint = getTileMapPoint(fromPosition: location, tileMapNode: tileMapNode)
        let row = tileMapNode.tileRowIndex(fromPosition: tileMapPoint)
        let column = tileMapNode.tileColumnIndex(fromPosition: tileMapPoint)

        guard tileMapNode.isRowValid(row), tileMapNode.isColumnValid(column) else {
            return nil
        }

        return (row, column)
    }

    private func getTileMapPoint(fromPosition location: CGPoint, tileMapNode: SKTileMapNode) -> CGPoint {
        let tileMapPoint = CGPoint(
            x: floor(location.x / tileMapNode.tileSize.width) * tileMapNode.tileSize.width,
            y: floor(location.y / tileMapNode.tileSize.height) * tileMapNode.tileSize.height
        )

        return tileMapPoint
    }
}
