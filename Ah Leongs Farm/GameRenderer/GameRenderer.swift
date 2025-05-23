import SpriteKit

/// The `GameRenderer` class is responsible for rendering the game world.
/// It manages different render managers and coordinates the rendering process
/// for various entities in the game.
class GameRenderer {
    private weak var gameScene: GameScene?
    private var renderPipeline: Queue<any IRenderManager> = Queue()

    private var tileMapNode: TileMapNode?
    private var entityNodeMap: [EntityID: any IRenderNode] = [:]

    private static let PriorityMap: [EntityType: CGFloat] = [
        Plot.type: CGFloat.greatestFiniteMagnitude
    ]

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
        tileMapNode = node

        let renderNode: any IRenderNode = node
        setRenderNode(for: entityID, node: renderNode)
    }

    func setRenderNode(for entityID: EntityID, node: any IRenderNode) {
        let shouldAddToScene = entityNodeMap[entityID] == nil

        entityNodeMap[entityID] = node

        if shouldAddToScene {
            gameScene?.addChild(node.getSKNode())
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
        guard let node = entityNodeMap[entityID] else {
            return
        }

        node.getSKNode().removeFromParent()
        entityNodeMap.removeValue(forKey: entityID)

        if node === tileMapNode {
            tileMapNode = nil
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

        let entitiesToUpdateFor = getEntitiesForUpdate(allEntities: allEntities)

        for renderManager in renderPipeline.iterable {
            for entity in entitiesToUpdateFor {
                guard let node = entityNodeMap[entity.id] else {
                    continue
                }
                renderManager.transformNode(node, for: entity, in: self)
            }
        }
    }

    /// Get render nodes to create, sorted from highest to lowest priority.
    private func getEntitiesForCreation(allEntities: [Entity]) -> [Entity] {
        allEntities.filter { entity in
            entityNodeMap[entity.id] == nil
        }.sorted { a, b in
            let aPriority = Self.PriorityMap[a.type] ?? 0
            let bPriority = Self.PriorityMap[b.type] ?? 0

            return aPriority > bPriority
        }
    }

    private func getEntitiesForRemoval(allEntities: [Entity]) -> Set<EntityID> {
        let allEntityIDs = Set(allEntities.map { $0.id })
        let entityIDsWithRenderNodes = Set(entityNodeMap.keys)

        let entityIDsWithSpriteComponentRemoved = Set(
            allEntities.filter { entityNodeMap.keys.contains($0.id) }
                .filter { $0.getComponentByType(ofType: SpriteComponent.self) == nil }
                .filter {
                    // exclude entity with tile map node
                    entityNodeMap[$0.id] !== tileMapNode
                }
                .map { ObjectIdentifier($0) }
        )

        let entityIDsForRemoval = entityIDsWithRenderNodes
            .subtracting(allEntityIDs)
            .union(entityIDsWithSpriteComponentRemoved)

        return entityIDsForRemoval
    }

    private func getEntitiesForUpdate(allEntities: [Entity]) -> [Entity] {
        allEntities.filter { entity in
            entityNodeMap[entity.id] != nil
        }.filter {
            $0.getComponentByType(ofType: RenderComponent.self)?.updatable == true
        }
    }
}

extension GameRenderer: IGameObserver {
    func observe(entities: [Entity]) {
        guard let scene = gameScene else {
            return
        }
        let renderEntities = entities.filter {
            $0.getComponentByType(ofType: RenderComponent.self) != nil
        }

        executeRenderPipeline(allEntities: renderEntities, in: scene)
    }
}

extension GameRenderer: UIPositionProvider {

    func getUIPosition(row: Int, column: Int) -> CGPoint? {
        guard let tileMapNode = tileMapNode else {
            return nil
        }

        guard tileMapNode.isRowValid(row), tileMapNode.isColumnValid(column) else {
            return nil
        }

        let tileSize = tileMapNode.tileSize

        let xPosition = CGFloat(column) * tileSize.width + tileSize.width / 2
            - tileMapNode.mapSize.width / 2
        let yPosition = CGFloat(row) * tileSize.height + tileSize.height / 2
            - tileMapNode.mapSize.height / 2

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
