import GameplayKit

class GameManager {
    private let gameWorld: GameWorld

    init(scene: SKScene) {
        gameWorld = GameWorld()
        setUpEntities()
        setUpSystems(scene: scene)
    }

    func update(_ currentTime: TimeInterval) {
        gameWorld.updateSystems(deltaTime: currentTime)
    }

    private func setUpEntities() {
        gameWorld.addEntity(FarmLand(rows: 20, columns: 20))
    }

    private func setUpSystems(scene: SKScene) {
        gameWorld.addSystem(TileMapSystem(scene: scene))
    }
}
