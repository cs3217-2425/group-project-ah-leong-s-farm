import GameplayKit
import SpriteKit

class GameManager {
    let gameWorld: GameWorld
    private var gameObservers: [any IGameObserver] = []

    init() {
        gameWorld = GameWorld()
        setUpBaseEntities()
        setUpQuests()
    }

    func update(_ currentTime: TimeInterval) {
        gameWorld.update(deltaTime: currentTime)
        gameObservers.forEach { $0.observe() }
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
