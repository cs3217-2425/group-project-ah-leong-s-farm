import GameplayKit

class GameManager {
    private let gameWorld: GameWorld
    private var gameObservers: [any IGameObserver] = []
    private var eventDispatcher: EventDispatcher

    init(scene: SKScene) {
        gameWorld = GameWorld()
        eventDispatcher = EventDispatcher(context: gameWorld)
        setUpEntities()
        setUpGameObservers(scene: scene)
    }

    func queueEvent(_ event: GameEvent) {
        eventDispatcher.queueEvent(event)
    }

    func update(_ currentTime: TimeInterval) {
        gameWorld.updateSystems(deltaTime: currentTime)
        eventDispatcher.processEvents()
        gameObservers.forEach { $0.notify(gameWorld) }
    }

    private func setUpEntities() {
        gameWorld.addEntity(FarmLand(rows: 20, columns: 20))
    }

    private func setUpGameObservers(scene: SKScene) {
        gameObservers.append(GameRenderer(scene: scene))
    }
}
