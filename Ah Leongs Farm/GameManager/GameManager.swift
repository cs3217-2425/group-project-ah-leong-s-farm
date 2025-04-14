import Foundation

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
        let entities = gameWorld.getAllEntities()

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

    func nextTurn() {
        gameWorld.queueEvent(EndTurnEvent())
    }

    func getCurrentTurn() -> Int {
        guard let turnSystem = gameWorld.getSystem(ofType: TurnSystem.self) else {
            return 1
        }

        return turnSystem.getCurrentTurn()
    }

    func getMaxTurns() -> Int {
        guard let turnSystem = gameWorld.getSystem(ofType: TurnSystem.self) else {
            return 1
        }

        return turnSystem.getMaxTurns()
    }

    func getAmountOfCurrency(_ type: CurrencyType) -> Double {
        guard let currencySystem = gameWorld.getSystem(ofType: WalletSystem.self) else {
            return 0
        }

        return currencySystem.getTotalAmount(of: .coin)
    }

    func getMaxEnergy() -> Int {
        guard let energySystem = gameWorld.getSystem(ofType: EnergySystem.self) else {
            return 0
        }

        return energySystem.getMaxEnergy()
    }

    func getCurrentEnergy() -> Int {
        guard let energySystem = gameWorld.getSystem(ofType: EnergySystem.self) else {
            return 0
        }

        return energySystem.getCurrentEnergy()
    }

    func ensureTargetActiveQuestCount(target: Int = 3) {
        guard let questSystem = gameWorld.getSystem(ofType: QuestSystem.self) else {
            return
        }
        questSystem.ensureTargetActiveQuestCount(target: target)
    }

    func getCurrentLevel() -> Int {
        guard let levelSystem = gameWorld.getSystem(ofType: LevelSystem.self) else {
            return 1
        }

        return levelSystem.getCurrentLevel()
    }

    func getCurrentXP() -> Float {
        guard let levelSystem = gameWorld.getSystem(ofType: LevelSystem.self) else {
            return 0
        }

        return levelSystem.getCurrentXP()
    }

    func getXPForCurrentLevel() -> Float {
        guard let levelSystem = gameWorld.getSystem(ofType: LevelSystem.self) else {
            return 0
        }

        return levelSystem.getXPForCurrentLevel()
    }

    func registerEventObserver(_ observer: IEventObserver) {
        gameWorld.registerEventObserver(observer)
    }

    // MARK: - Setup Methods

    private func setUpBaseEntities() {
        setUpGameStateEntity()

        addStartingItems()

        setUpFarmLandEntity()
    }

    private func setUpGameStateEntity() {
        let gameStateQuery = CoreDataGameStateQuery()

        let gameState = gameStateQuery?.fetch() ?? GameState(maxTurns: 30, maxEnergy: 10)

        gameWorld.addEntity(gameState)
    }

    private func setUpFarmLandEntity() {
        let farmLand = FarmLand(rows: 10, columns: 10)
        gameWorld.addEntity(farmLand)

        let plotQuery = CoreDataPlotQuery()
        let plots = plotQuery?.fetch() ?? []

        guard let gridComponent = farmLand.getComponentByType(ofType: GridComponent.self) else {
            return
        }

        for plot in plots {
            guard let position = plot.getComponentByType(ofType: PositionComponent.self) else {
                continue
            }

            let row = Int(position.x)
            let column = Int(position.y)

            gridComponent.setEntity(plot, row: row, column: column)
            gameWorld.addEntity(plot)
        }
    }

    private func setUpQuests() {
        let quests = QuestFactory.createAllQuests()
        for quest in quests {
            gameWorld.addEntity(quest)
        }
        ensureTargetActiveQuestCount()
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
}
