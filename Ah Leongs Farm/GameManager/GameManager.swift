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
        gameWorld.addEntity(GameState(maxTurns: 30, maxEnergy: 10))
        gameWorld.addEntity(Wallet())
        gameWorld.addEntity(Inventory())
        gameWorld.addEntity(Level(level: 1, currentXP: 0))
        gameWorld.addEntity(Quest(
            objectives: [QuestObjective(description: "Collect 10 apples", progress: 0, target: 10)],
            reward: Reward(rewards: [.xp(100)])))

        let farmLand = FarmLand(rows: 20, columns: 20)
        gameWorld.addEntity(farmLand)

        if let gridComponent = farmLand.component(ofType: GridComponent.self) {
            setUpPlotEntities(using: gridComponent)
        }
    }

    private func setUpSystems() {
        gameWorld.addSystem(EnergySystem())
        gameWorld.addSystem(TurnSystem())
        gameWorld.addSystem(WalletSystem())
        gameWorld.addSystem(InventorySystem())
        gameWorld.addSystem(LevelSystem())
        gameWorld.addSystem(QuestSystem())
        gameWorld.addSystem(CropSystem())
        gameWorld.addSystem(GridSystem())
    }

    private func setUpGameObservers(scene: SKScene) {
        gameObservers.append(GameRenderer(scene: scene))
    }

    private func setUpPlotEntities(using grid: GridComponent) {
        for row in 0..<grid.numberOfRows {
            for column in 0..<grid.numberOfColumns {
                let plot = Plot(position: CGPoint(x: row, y: column))
                grid.setEntity(plot, row: row, column: column)
                gameWorld.addEntity(plot)
            }
        }
    }
}
