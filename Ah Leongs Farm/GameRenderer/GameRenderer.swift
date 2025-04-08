import SpriteKit

/// The `GameRenderer` class is responsible for rendering the game world.
/// It manages different render managers and coordinates the rendering process
/// for various entities in the game.
class GameRenderer {
    private weak var gameScene: GameScene?
    private var renderPipeline: Queue<any IRenderManager> = Queue()

    private var entityTileMapNodeMap: [EntityID: TileMapNode] = [:]
    private var entitySpriteNodeMap: [EntityID: SpriteNode] = [:]
    private var entityNodeMap: [EntityID: any IRenderNode] {
        let maps: [[EntityID: any IRenderNode]] = [entityTileMapNodeMap, entitySpriteNodeMap]
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

    func setRenderNode(for entityID: EntityID, node: TileMapNode) {
        let shouldAddToScene = entityTileMapNodeMap[entityID] == nil

        entityTileMapNodeMap[entityID] = node

        if shouldAddToScene {
            gameScene?.addChild(node)
        }
    }

    func setRenderNode(for entityID: EntityID, node: SpriteNode) {
        let shouldAddToScene = entitySpriteNodeMap[entityID] == nil

        entitySpriteNodeMap[entityID] = node

        if shouldAddToScene {
            gameScene?.addChild(node)
        }
    }

    func lightUpTile(at row: Int, column: Int) {
        guard let tileMapNode = tileMapNode else {
            return
        }

        let transparentGreen = #colorLiteral(red: 0, green: 1, blue: 0, alpha: 0.5)
        tileMapNode.lightUpTile(atRow: row, column: column, color: transparentGreen, blendFactor: 0.5)
    }

    func unlightAllTiles() {
        tileMapNode?.removeAllLightUpTiles()
    }

    private func removeRenderNode(for entityID: EntityID) {
        if let node = entityTileMapNodeMap[entityID] {
            node.removeFromParent()
            entityTileMapNodeMap.removeValue(forKey: entityID)
        } else if let node = entitySpriteNodeMap[entityID] {
            node.removeFromParent()
            entitySpriteNodeMap.removeValue(forKey: entityID)
        }
    }

    private func removeAllRenderNodes() {
        for entityID in entityNodeMap.keys {
            removeRenderNode(for: entityID)
        }
    }

    private func setUpRenderPipeline() {
        renderPipeline.enqueue(TileMapRenderManager())
        renderPipeline.enqueue(SpriteRenderManager(uiPositionProvider: self))
    }

    private func executeRenderPipeline(allEntities: [Entity], in scene: GameScene) {
        let entitiesToCreateFor = getEntitiesForCreation(allEntities: allEntities)
        let entityIDsToRemove = getEntitiesForRemoval(allEntities: allEntities)

        for renderManager in renderPipeline.iterable {
            for entity in entitiesToCreateFor {
                renderManager.createNode(for: entity, in: self)
            }
        }

        for entityID in entityIDsToRemove {
            removeRenderNode(for: entityID)
        }
    }

    private func getEntitiesForCreation(allEntities: [Entity]) -> [Entity] {
        allEntities.filter { entity in
            entityNodeMap[entity.id] == nil
        }
    }

    private func getEntitiesForRemoval(allEntities: [Entity]) -> Set<EntityID> {
        let allentityIDs = Set(allEntities.map { $0.id })
        let entityIDsWithRenderNodes = Set(entityNodeMap.keys)

        let entityIDsWithPositionComponentRemoved = Set(
            allEntities.filter { entitySpriteNodeMap.keys.contains(ObjectIdentifier($0)) }
                .filter { $0.component(ofType: PositionComponent.self) == nil }
                .map { ObjectIdentifier($0) }
        )

        let entityIDsForRemoval = entityIDsWithRenderNodes
            .subtracting(allentityIDs)
            .union(entityIDsWithPositionComponentRemoved)

        return entityIDsForRemoval
    }
}

extension GameRenderer: IGameObserver {
    func observe(entities: [Entity]) {
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
