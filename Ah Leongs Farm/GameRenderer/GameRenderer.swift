import SpriteKit

/// The GameRenderer class is responsible for rendering the game world.
class GameRenderer {
    private weak var gameManager: GameManager?
    private weak var gameScene: GameScene?

    private var entityNodeMap: [ObjectIdentifier: IRenderNode] = [:]
    private var renderSystems: [any IRenderSystem] = []

    init(gameManager: GameManager) {
        self.gameManager = gameManager
        setUpRenderSystems()
        self.gameManager?.addGameObserver(self)
    }

    func setScene(_ scene: GameScene?) {
        gameScene = scene
        gameScene?.setGameSceneUpdateDelegate(self)
    }

    private func setUpRenderSystems() {
        renderSystems.append(TileMapRenderSystem())
    }
}

extension GameRenderer: GameSceneUpdateDelegate {
    func update(_ timeInterval: TimeInterval) {
        gameManager?.update(timeInterval)
    }
}

extension GameRenderer: IGameObserver {
    func observe() {
        guard let gameWorld = gameManager?.gameWorld else {
            return
        }

        let entitiesToRender = gameWorld.entities.filter { entity in
            entityNodeMap[ObjectIdentifier(entity)] == nil
        }

        for renderSystem in renderSystems {
            for entity in entitiesToRender {
                if let node = renderSystem.createNode(of: entity) {
                    gameScene?.addChild(node.skNode)
                    entityNodeMap[ObjectIdentifier(entity)] = node
                }
            }
        }
    }
}
