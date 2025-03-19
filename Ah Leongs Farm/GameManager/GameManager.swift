import GameplayKit

class GameManager {
    private let gameWorld: GameWorld
    private var gameObservers: [any IGameObserver] = []

    init(scene: SKScene) {
        gameWorld = GameWorld()
        setUpSystems()
        setUpEntities()
        setUpGameObservers(scene: scene)
    }

    func update(_ currentTime: TimeInterval) {
        gameWorld.updateSystems(deltaTime: currentTime)
        gameObservers.forEach { $0.notify(gameWorld) }
    }

    private func setUpSystems() {
        gameWorld.addSystem(EnergySystem())
        gameWorld.addSystem(TurnSystem())
    }

    private func setUpEntities() {
        gameWorld.addEntity(FarmLand(rows: 20, columns: 20))
        gameWorld.addEntity(GameState(maxTurns: 30, maxEnergy: 10))
    }

    private func setUpGameObservers(scene: SKScene) {
        gameObservers.append(GameRenderer(scene: scene))
    }
}
