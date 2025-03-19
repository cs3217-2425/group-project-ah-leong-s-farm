import GameplayKit

class GameManager {
    private let gameWorld: GameWorld
    private var gameObservers: [any IGameObserver] = []
    private var eventDispatcher: EventDispatcher?

    init(scene: SKScene) {
        gameWorld = GameWorld()
        setUpSystems()
        setUpEntities()
        setUpGameObservers(scene: scene)
        eventDispatcher = EventDispatcher(context: self)
    }

    func update(_ currentTime: TimeInterval) {
        guard let eventDispatcher = eventDispatcher else {
            return
        }
        gameWorld.updateSystems(deltaTime: currentTime)
        eventDispatcher.processEvents()
        gameObservers.forEach { $0.notify(gameWorld) }
    }

    private func setUpEntities() {
        gameWorld.addEntity(FarmLand(rows: 20, columns: 20))
        gameWorld.addEntity(GameState(maxTurns: 30, maxEnergy: 10))
        gameWorld.addEntity(Wallet())
    }

    private func setUpSystems() {
        gameWorld.addSystem(EnergySystem())
        gameWorld.addSystem(TurnSystem())
        gameWorld.addSystem(WalletSystem())
    }

    private func setUpGameObservers(scene: SKScene) {
        gameObservers.append(GameRenderer(scene: scene))
    }
}

extension GameManager: EventContext {
    func getSystem<T>(ofType: T.Type) -> T? {
        return gameWorld.getSystem(ofType: ofType)
    }

    func queueEvent(_ event: GameEvent) {
        guard let eventDispatcher = eventDispatcher else {
            return
        }
        eventDispatcher.queueEvent(event)
    }
}
