import SpriteKit

class GameRenderer {
    private let scene: SKScene

    private let tileMapRenderManager: TileMapRenderManager
    private let spriteRenderManager: SpriteRenderManager

    private var renderManagers: [any IRenderManager] {
        [tileMapRenderManager, spriteRenderManager]
    }

    init(scene: SKScene) {
        self.scene = scene
        self.tileMapRenderManager = TileMapRenderManager()
        self.spriteRenderManager = SpriteRenderManager(tileMapDelegate: self.tileMapRenderManager)
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
