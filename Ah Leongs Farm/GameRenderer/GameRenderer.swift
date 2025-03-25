import SpriteKit

class GameRenderer: IGameObserver {
    private let scene: SKScene

    private var entityNodeMap: [ObjectIdentifier: IRenderNode] = [:]
    private var renderSystems: [any IRenderSystem] = []

    init(scene: SKScene) {
        self.scene = scene
        setUpRenderSystems()
    }

    func notify(_ gameWorld: GameWorld) {
        let allEntities = gameWorld.getAllEntities()
        let entitiesToRender = allEntities.filter { entity in
            entityNodeMap[ObjectIdentifier(entity)] == nil
        }

        for renderSystem in renderSystems {
            for entity in entitiesToRender {
                if let node = renderSystem.createNode(of: entity) {
                    scene.addChild(node.skNode)
                    entityNodeMap[ObjectIdentifier(entity)] = node
                }
            }
        }
    }

    private func setUpRenderSystems() {
        renderSystems.append(TileMapRenderSystem())
    }
}
