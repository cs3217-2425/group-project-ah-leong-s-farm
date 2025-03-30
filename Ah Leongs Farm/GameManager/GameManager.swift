import GameplayKit
import SpriteKit

class GameManager {
    let gameWorld: GameWorld
    private var gameObservers: [any IGameObserver] = []
    private var previousTime: TimeInterval = 0

    init() {
        gameWorld = GameWorld()
        setUpBaseEntities()
        setUpQuests()
    }

    func update(_ currentTime: TimeInterval) {
        let deltaTime = max(currentTime - previousTime, 0) // Ensure deltaTime is not negative
        let entities = Set(gameWorld.getAllEntities())

        previousTime = currentTime
        gameWorld.update(deltaTime: deltaTime)
        gameObservers.forEach { $0.observe(entities: entities) }
    }

    func addGameObserver(_ observer: any IGameObserver) {
        gameObservers.append(observer)
    }

    func removeGameObserver(_ observer: any IGameObserver) {
        gameObservers.removeAll(where: { $0 === observer })
    }

    private func setUpEntities() {
        gameWorld.addEntity(GameState(maxTurns: 30, maxEnergy: 10))
    }

    // MARK: - Setup Methods

    private func setUpBaseEntities() {
        gameWorld.addEntity(GameState(maxTurns: 30, maxEnergy: 10))

        addStartingItems()

        let farmLand = FarmLand(rows: 20, columns: 20)
        gameWorld.addEntity(farmLand)
        if let gridComponent = farmLand.component(ofType: GridComponent.self) {
            setUpPlotEntities(using: gridComponent)
        }
    }

    private func setUpQuests() {
        let quests = QuestFactory.createAllQuests()
        for quest in quests {
            gameWorld.addEntity(quest)
        }
    }

    // MARK: - Entity Creation Helpers

    private func addStartingItems() {
        if let inventorySystem = gameWorld.getSystem(ofType: InventorySystem.self) {
            inventorySystem.addItem(type: .bokChoySeed, quantity: 5)
            // Additional starting items just to test the UI
            inventorySystem.addItem(type: .fertiliser, quantity: 3)
            inventorySystem.addItem(type: .premiumFertiliser, quantity: 6)
            inventorySystem.addItem(type: .appleSeed, quantity: 7)
            inventorySystem.addItem(type: .potatoSeed, quantity: 52)
            inventorySystem.addItem(type: .bokChoySeed, quantity: 5)
        }
    }

    private func setUpPlotEntities(using grid: GridComponent) {
        for row in 0..<grid.numberOfRows where row.isMultiple(of: 2) {
            for column in 0..<grid.numberOfColumns where column.isMultiple(of: 2) {
                let plot = Plot(position: CGPoint(x: row, y: column))
                grid.setEntity(plot, row: row, column: column)
                gameWorld.addEntity(plot)
            }
        }
    }
}
