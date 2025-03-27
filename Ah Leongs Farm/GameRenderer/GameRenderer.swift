import SpriteKit

class GameRenderer {
    private let scene: SKScene

    private var entityNodeMap: [ObjectIdentifier: IRenderNode] = [:]
    private var renderManagers: [any IRenderManager] = []

    init(scene: SKScene) {
        self.scene = scene
        setUpRenderSystems()
    }

    private func setUpRenderSystems() {
        renderManagers.append(TileMapRenderManager())
        renderManagers.append(SpriteRenderManager())
    }
}

extension GameRenderer: IGameObserver {
    func notify(_ gameWorld: GameWorld) {
        let allEntities = gameWorld.entities

        let entitiesToRender = allEntities.filter { entity in
            entityNodeMap[ObjectIdentifier(entity)] == nil
        }

        let entitiesToUpdate = allEntities.filter { entity in
            entityNodeMap[ObjectIdentifier(entity)] != nil
        }

        for renderManager in renderManagers {
            for entity in entitiesToRender {
                if let node = renderManager.createNode(of: entity) {
                    scene.addChild(node.skNode)
                    entityNodeMap[ObjectIdentifier(entity)] = node
                }
            }

            for entity in entitiesToUpdate {
                guard var node = entityNodeMap[ObjectIdentifier(entity)] else {
                    continue
                }
                renderManager.updateNode(for: &node, using: entity)
            }
        }
    }
}
