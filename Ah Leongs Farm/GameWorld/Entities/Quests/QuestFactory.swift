//
//  QuestFactory.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 21/3/25.
//

import Foundation

class QuestFactory {

    // MARK: QuestObjective helper functions
    private static func createPlantCropObjective(type: CropType,
                                                 plantAmount: Int) -> QuestObjective {
        let plantCropCriteria = PlantCropCriteria(cropType: type)
        return QuestObjective(
            description: "Plant \(plantAmount) \(type)s",
            criteria: plantCropCriteria,
            target: Float(plantAmount)
        )
    }

    private static func createHarvestCropObjective(type: CropType,
                                                   harvestAmount: Int) -> QuestObjective {
        let harvestCropCriteria = HarvestCropCriteria(cropType: type)
        return QuestObjective(
            description: "Harvest \(harvestAmount) \(type)s",
            criteria: harvestCropCriteria,
            target: Float(harvestAmount)
        )
    }

    private static func createSellItemObjective(type: ItemType,
                                                sellAmount: Int) -> QuestObjective {
        let sellCropCriteria = SellItemCriteria(itemType: type)
        let displayName = ItemToViewDataMap.itemTypeToDisplayName[type]
        return QuestObjective(
            description: "Sell \(sellAmount) \(displayName ?? "Item")s",
            criteria: sellCropCriteria,
            target: Float(sellAmount)
        )
    }

    private static func createSurvivalObjective(days: Int) -> QuestObjective {
        let survivalCriteria = SurviveNumberOfTurnsCriteria()
            return QuestObjective(description: "Survive for \(days) days",
                                  criteria: survivalCriteria,
                                  target: Float(days))
    }

    // MARK: - Multi-Objective Quests

    private static func createFarmBusinessQuest(
        cropType: CropType = .apple,
        sellItemType: ItemType = .appleHarvested,
        harvestAmount: Int = 15,
        sellAmount: Int = 10,
        survivalDays: Int = 3,
        order: Int = Int.max
    ) -> Quest {
        // First objective: Harvest crops
        let harvestObjective = createHarvestCropObjective(type: .apple,
                                                          harvestAmount: harvestAmount)

        // Second objective: Sell crops
        let sellObjective = createSellItemObjective(type: sellItemType,
                                                    sellAmount: sellAmount)

        // Third objective: Survive days
        let survivalObjective = createSurvivalObjective(days: survivalDays)

        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 150),
            RewardCurrencyComponent(currencies: [.coin: 200]),
            RewardItemComponent(itemTypes: [.fertiliser: 2,
                                            .potatoSeed: 3])
        ]

        // Create the quest with all objectives
        let title = "\(cropType.rawValue.capitalized) Business Venture"

        let component = QuestComponent(
            title: title,
            objectives: [harvestObjective, sellObjective, survivalObjective],
            order: order
        )

        return Quest(questComponent: component,
                     rewardComponents: rewards)
    }

    // MARK: - Other Quests

    private static func createAppleHarvestQuest(order: Int = Int.max) -> Quest {
        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 100),
            RewardCurrencyComponent(currencies: [.coin: 50])
        ]

        let harvestObjective = createHarvestCropObjective(type: .apple,
                                                          harvestAmount: 10)

        let title = "Apple Collection"

        let component = QuestComponent(title: title,
                                       objectives: [harvestObjective],
                                       order: order)

        return Quest(questComponent: component,
                     rewardComponents: rewards)
    }

    private static func createFarmStarterQuest(order: Int = Int.max) -> Quest {
        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 50),
            RewardItemComponent(itemTypes: [.premiumFertiliser: 1])
        ]

        let survivalObjective = createSurvivalObjective(days: 7)

        let title = "Farm Beginnings"

        let component = QuestComponent(title: title,
                                       objectives: [survivalObjective],
                                       order: order)

        return Quest(questComponent: component,
                     rewardComponents: rewards)
    }

    private static func createSellQuestBakChoy(order: Int = Int.max) -> Quest {
        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 75),
            RewardCurrencyComponent(currencies: [.coin: 100])
        ]

        let sellObjective = createSellItemObjective(type: .bokChoyHarvested,
                                                    sellAmount: 8)

        let title = "Market sales"

        let component = QuestComponent(title: title,
                                       objectives: [sellObjective],
                                       order: order)

        return Quest(questComponent: component,
                     rewardComponents: rewards)
    }

    private static func createReallyLongQuest(order: Int = Int.max) -> Quest {
        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 150),
            RewardCurrencyComponent(currencies: [.coin: 200]),
            RewardItemComponent(itemTypes: [.fertiliser: 2,
                                            .potatoSeed: 3])
        ]

        let plantAppleObjective = createPlantCropObjective(type: .apple, plantAmount: 5)
        let plantBokChoyObjective = createPlantCropObjective(type: .bokChoy, plantAmount: 5)
        let plantPotatoObjective = createPlantCropObjective(type: .potato, plantAmount: 5)

        let harvestAppleObjective = createHarvestCropObjective(type: .apple, harvestAmount: 10)
        let harvestPotatoObjective = createHarvestCropObjective(type: .potato, harvestAmount: 10)
        let harvestBokChoyObjective = createHarvestCropObjective(type: .bokChoy, harvestAmount: 15)

        let sellAppleObjective = createSellItemObjective(type: .appleHarvested, sellAmount: 10)
        let sellPotatoObjective = createSellItemObjective(type: .potatoHarvested, sellAmount: 10)
        let sellBokChoyObjective = createSellItemObjective(type: .bokChoyHarvested, sellAmount: 15)

        let survivalObjective = createSurvivalObjective(days: 5)

        let title = "Realllllly looooong quest"
        let component = QuestComponent(title: title,
                                       objectives: [
                                        plantAppleObjective,
                                        plantBokChoyObjective,
                                        plantPotatoObjective,
                                        harvestAppleObjective,
                                        harvestPotatoObjective,
                                        harvestBokChoyObjective,
                                        sellAppleObjective,
                                        sellPotatoObjective,
                                        sellBokChoyObjective,
                                        survivalObjective
                                       ],
                                       order: order)
        return Quest(questComponent: component,
                     rewardComponents: rewards)
    }

    private static func createBakChoyHarvestQuest(order: Int = Int.max) -> Quest {
        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 25)
        ]

        let harvestObjective = createHarvestCropObjective(type: .bokChoy,
                                                          harvestAmount: 3)

        let title = "Learning to harvest"

        let component = QuestComponent(title: title,
                                       objectives: [harvestObjective],
                                       order: order)

        return Quest(questComponent: component,
                     rewardComponents: rewards)

    }

    private static func createDummyQuest(days: Int,
                                         order: Int = Int.max) -> Quest {
        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 50),
            RewardItemComponent(itemTypes: [.premiumFertiliser: 1]),
            RewardCurrencyComponent(currencies: [
                .coin: 100
            ])
        ]

        let survivalObjective = createSurvivalObjective(days: days)

        let title = "Dummy quest \(UUID())"

        let component = QuestComponent(title: title,
                                       objectives: [survivalObjective],
                                       order: order)

        return Quest(questComponent: component,
                     rewardComponents: rewards)
    }

    static func createAllQuests() -> [Quest] {
        [
            createFarmStarterQuest(order: 1),
            createBakChoyHarvestQuest(order: 7),
            createSellQuestBakChoy(order: 8),
            createFarmBusinessQuest(order: 9),
            createAppleHarvestQuest(order: 10),
            createReallyLongQuest(order: 11)
        ]
    }

}
