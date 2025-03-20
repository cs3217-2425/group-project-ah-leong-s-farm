import GameplayKit

// GameManager.swift
import GameplayKit
import SpriteKit

class GameManager {
    private let gameWorld: GameWorld
    private var gameObservers: [any IGameObserver] = []

    init(scene: SKScene) {
        // Initialize game world
        gameWorld = GameWorld()

        // Set up systems first
        setUpSystems()

        // Set up base entities
        setUpBaseEntities()

        // Set up quests - do this after setting up systems and base entities
        setUpQuests()

        // Set up renderers and observers
        setUpGameObservers(scene: scene)
    }

    func update(_ currentTime: TimeInterval) {
        // Update game world (which updates systems and processes events)
        gameWorld.update(deltaTime: currentTime)

        // Notify observers about the updated game state
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
        // Core game systems
        gameWorld.addSystem(EnergySystem())
        gameWorld.addSystem(TurnSystem())
        gameWorld.addSystem(WalletSystem())
        gameWorld.addSystem(InventorySystem())
        gameWorld.addSystem(LevelSystem())
        gameWorld.addSystem(CropSystem())

        // Quest system needs special handling for event observation
        let questSystem = QuestSystem(eventContext: gameWorld)
        gameWorld.addSystem(questSystem)
        gameWorld.registerEventObserver(questSystem)
    }

    private func setUpBaseEntities() {
        // Farm and world entities
        gameWorld.addEntity(GameState(maxTurns: 30, maxEnergy: 10))

        // Player-related entities
        gameWorld.addEntity(Wallet())
        gameWorld.addEntity(Inventory())
        gameWorld.addEntity(Level(level: 1, currentXP: 0))

        // Add starting items to inventory
        addStartingItems()

        let farmLand = FarmLand(rows: 20, columns: 20)
        gameWorld.addEntity(farmLand)
        if let gridComponent = farmLand.component(ofType: GridComponent.self) {
            setUpPlotEntities(using: gridComponent)
        }
    }

    private func setUpQuests() {
        addMainStoryQuests()
        addSideQuests()
        addTutorialQuests()
    }

    private func setUpGameObservers(scene: SKScene) {
        gameObservers.append(GameRenderer(scene: scene))
    }

    // MARK: - Entity Creation Helpers

    private func addStartingItems() {
        if let inventorySystem = gameWorld.getSystem(ofType: InventorySystem.self) {
            let seedItem = createSeedItem(type: .bokChoySeed, quantity: 5)
            inventorySystem.addItem(seedItem)
        }
    }

    private func createSeedItem(type: ItemType, quantity: Int) -> GKEntity {
        let entity = GKEntity()
        let itemComponent = ItemComponent(itemType: type, stackable: true)
        itemComponent.quantity = quantity
        entity.addComponent(itemComponent)
        return entity
    }

    // MARK: - Quest Setup Methods

    private func addMainStoryQuests() {
        // Main story questline - typically would be sequential

        // First main quest - Apple collection quest
        let appleQuest = QuestFactory.createAppleCollectionQuest()
        gameWorld.addEntity(appleQuest)

        // Farm business quest (more complex, multi-objective)
        let businessReward = Reward(rewards: [
            .currency(.coin, 200),
            .xp(150),
            .item("premium_fertilizer", 2)
        ])

        let farmBusinessQuest = QuestFactory.createFarmBusinessQuest(
            cropType: .apple,
            reward: businessReward
        )

        gameWorld.addEntity(farmBusinessQuest)
    }

    private func addSideQuests() {
        // Side quests - optional quests for additional rewards

        // Create a survival side quest
        let survivalQuest = QuestFactory.createFarmStarterQuest()
        gameWorld.addEntity(survivalQuest)

        // Create a sell quest
        let sellQuestReward = Reward(rewards: [
            .currency(.coin, 100),
            .xp(75)
        ])

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

        // Very simple harvest quest with small reward
        let tutorialReward = Reward(rewards: [.xp(25)])

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
