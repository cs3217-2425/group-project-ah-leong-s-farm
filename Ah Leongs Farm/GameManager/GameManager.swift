import Foundation

class GameManager {
    let gameWorld: GameWorld
    let persistenceManager: PersistenceManager
    private var gameObservers: [any IGameObserver] = []
    private var previousTime: TimeInterval = 0

    init(sessionId: UUID) {
        gameWorld = GameWorld()
        persistenceManager = PersistenceManager(sessionId: sessionId)
        setUpBaseEntities()
        setUpQuests()

        addGameObserver(persistenceManager)
    }

    convenience init() {
        self.init(sessionId: UUID())
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

    func getMaxEnergy(of type: EnergyType) -> Int {
        guard let energySystem = gameWorld.getSystem(ofType: EnergySystem.self) else {
            return 0
        }

        return energySystem.getMaxEnergy(of: type)
    }

    func getCurrentEnergy(of type: EnergyType) -> Int {
        guard let energySystem = gameWorld.getSystem(ofType: EnergySystem.self) else {
            return 0
        }

        return energySystem.getCurrentEnergy(of: type)
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

    private func setUpBaseEntities(shouldUsePreloadedSetUp: Bool = false) {
        setUpGameStateEntity(shouldUsePreloadedSetUp: shouldUsePreloadedSetUp)

        addStartingItems()

        setUpFarmLandEntity(shouldUsePreloadedSetUp: shouldUsePreloadedSetUp)
    }

    private func setUpGameStateEntity(shouldUsePreloadedSetUp: Bool) {
        let defaultGameState = GameState(maxTurns: 30)

        if shouldUsePreloadedSetUp {
            gameWorld.addEntity(defaultGameState)
            return
        }

        let gameState = persistenceManager.loadGameState() ?? defaultGameState

        gameWorld.addEntity(gameState)
    }

    private func setUpFarmLandEntity(shouldUsePreloadedSetUp: Bool) {
        let farmLand = FarmLand(rows: 10, columns: 10)
        gameWorld.addEntity(farmLand)

        if shouldUsePreloadedSetUp {
            // do not create plots
            return
        }

        let plots = persistenceManager.loadPlots()

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
            inventorySystem.addItems(ItemFactory.createItems(type: BokChoySeed.type, quantity: 5))
            // Additional starting items just to test the UI
            inventorySystem.addItems(ItemFactory.createItems(type: Fertiliser.type, quantity: 3))
            inventorySystem.addItems(ItemFactory.createItems(type: PremiumFertiliser.type, quantity: 6))
            inventorySystem.addItems(ItemFactory.createItems(type: AppleSeed.type, quantity: 3))
            inventorySystem.addItems(ItemFactory.createItems(type: BokChoySeed.type, quantity: 3))
        }
    }
}
