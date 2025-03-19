import GameplayKit

class GameManager {
    private let gameWorld: GameWorld
    private var gameObservers: [any IGameObserver] = []
    private var eventDispatcher: EventDispatcher

    init(scene: SKScene) {
        gameWorld = GameWorld()
        eventDispatcher = EventDispatcher(context: gameWorld)
        setUpSystems()
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
        let farmLand = FarmLand(rows: 20, columns: 20)
        gameWorld.addEntity(farmLand)

        guard let gridComponent = farmLand.component(ofType: GridComponent.self) else {
            return
        }

        for row in 0..<gridComponent.numberOfRows {
            for column in 0..<gridComponent.numberOfColumns {
                let plot = Plot(position: CGPoint(x: row, y: column))
                gridComponent.setObject(plot, row: row, column: column)
                gameWorld.addEntity(plot)
            }
        }

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
