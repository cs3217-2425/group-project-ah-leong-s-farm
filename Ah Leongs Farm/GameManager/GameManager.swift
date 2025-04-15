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

    func getCurrentUpgradePoints() -> Int {
        guard let upgradeSystem = gameWorld.getSystem(ofType: UpgradeSystem.self) else {
            return 0
        }

        return upgradeSystem.getUpgradePoints()
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

    private func setUpEntities() {
        gameWorld.addEntity(GameState(maxTurns: 30))
    }

    // MARK: - Setup Methods

    private func setUpBaseEntities() {

        gameWorld.addEntity(GameState(maxTurns: 30))

        addStartingItems()

        let farmLand = FarmLand(rows: 10, columns: 10)
        gameWorld.addEntity(farmLand)
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
        let bokChoySeeds = SeedFactory.createMultiple(type: BokChoySeed.type, quantity: 8)
        let fertilisers = ToolFactory.createMultiple(type: Fertiliser.type, quantity: 3)
        let premiumFertilisers = ToolFactory.createMultiple(type: PremiumFertiliser.type, quantity: 6)
        let appleSeeds = SeedFactory.createMultiple(type: AppleSeed.type, quantity: 3)

        let allItems = bokChoySeeds + fertilisers + premiumFertilisers + appleSeeds

        gameWorld.addEntities(allItems)

        if let marketSystem = gameWorld.getSystem(ofType: MarketSystem.self) {
            marketSystem.addEntitiesToSellMarket(entities: allItems)
        }

        if let inventorySystem = gameWorld.getSystem(ofType: InventorySystem.self) {
            inventorySystem.addItemsToInventory(allItems)
        }
    }

}
