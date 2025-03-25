import GameplayKit
import SpriteKit

class GameManager {
    private let gameWorld: GameWorld
    private var gameObservers: [any IGameObserver] = []

    init(scene: SKScene) {
        gameWorld = GameWorld()
        setUpSystems()
        setUpBaseEntities()
        setUpQuests()
        setUpGameObservers(scene: scene)
    }

    func update(_ currentTime: TimeInterval) {
        gameWorld.update(deltaTime: currentTime)
        gameObservers.forEach { $0.notify(gameWorld) }
    }

    private func setUpEntities() {
        gameWorld.addEntity(GameState(maxTurns: 30, maxEnergy: 10))
        gameWorld.addEntity(Wallet())
        gameWorld.addEntity(Inventory())
        gameWorld.addEntity(Level(level: 1, currentXP: 0))
    }

    // MARK: - Setup Methods

    private func setUpSystems() {
        gameWorld.addSystem(EnergySystem())
        gameWorld.addSystem(TurnSystem())
        gameWorld.addSystem(WalletSystem())
        gameWorld.addSystem(InventorySystem())
        gameWorld.addSystem(LevelSystem())
        gameWorld.addSystem(CropSystem())
        gameWorld.addSystem(GridSystem())

        let questSystem = QuestSystem(eventQueueable: gameWorld)
        gameWorld.addSystem(questSystem)
        gameWorld.registerEventObserver(questSystem)
    }

    private func setUpBaseEntities() {
        gameWorld.addEntity(GameState(maxTurns: 30, maxEnergy: 10))

        gameWorld.addEntity(Wallet())
        gameWorld.addEntity(Inventory())
        gameWorld.addEntity(Level(level: 1, currentXP: 0))

        addStartingItems()

        let farmLand = FarmLand(rows: 20, columns: 20)
        gameWorld.addEntity(farmLand)
        if let gridComponent = farmLand.component(ofType: GridComponent.self) {
            setUpPlotEntities(using: gridComponent)
        }
    }

    private func setUpQuests() {
        addTutorialQuests()
        addMainStoryQuests()
        addMoreQuests()
    }

    private func setUpGameObservers(scene: SKScene) {
        gameObservers.append(GameRenderer(scene: scene))
    }

    // MARK: - Entity Creation Helpers

    private func addStartingItems() {
        if let inventorySystem = gameWorld.getSystem(ofType: InventorySystem.self) {
            let seedItem = inventorySystem.createItem(type: .bokChoySeed, quantity: 5)
            inventorySystem.addItem(seedItem)
        }
    }

    // MARK: - Quest Setup Methods

    private func addMainStoryQuests() {
        // First main quest - Apple collection quest
        let appleQuest = QuestFactory.createAppleCollectionQuest()
        gameWorld.addEntity(appleQuest)

        // Farm business quest (more complex, multi-objective)
        let businessReward = Reward(rewards: [
            XPSpecificReward(amount: 150),
            CurrencySpecificReward(currencies: [CurrencyType.coin: 200]),
            ItemSpecificReward(itemTypes: [ItemType.fertiliser: 2,
                                           ItemType.potatoSeed: 3])
        ])

        let farmBusinessQuest = QuestFactory.createFarmBusinessQuest(
            reward: businessReward,
            cropType: .apple
        )

        gameWorld.addEntity(farmBusinessQuest)
    }

    private func addMoreQuests() {

        // Create a survival quest
        let survivalQuest = QuestFactory.createFarmStarterQuest()
        gameWorld.addEntity(survivalQuest)

        let sellQuestReward = Reward(rewards: [
            XPSpecificReward(amount: 75),
            CurrencySpecificReward(currencies: [CurrencyType.coin: 100])
        ])

        // Create a sell quest
        let sellQuest = QuestFactory.createSellQuest(
            title: "Market Sales",
            cropType: .bokChoy,
            amount: 8,
            reward: sellQuestReward
        )

        gameWorld.addEntity(sellQuest)
    }

    private func addTutorialQuests() {
        // Tutorial quests - simple quests to teach game mechanics

        let tutorialReward = Reward(rewards: [
            XPSpecificReward(amount: 25)
        ])

        let tutorialQuest = QuestFactory.createHarvestQuest(
            title: "Learning to Harvest",
            cropType: .bokChoy,
            amount: 3,
            reward: tutorialReward
        )

        gameWorld.addEntity(tutorialQuest)
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
