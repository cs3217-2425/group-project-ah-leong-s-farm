//
//  QuestFactory.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 21/3/25.
//

import GameplayKit

class QuestFactory {
    // MARK: - Standard Quest Types

    private static func createHarvestQuest(
        title: String,
        cropType: CropType,
        amount: Int,
        rewards: [RewardComponent],
        order: Int = Int.max
    ) -> Quest {

        let criteria = HarvestCropCriteria(cropType: cropType)

        let objective = QuestObjective(
            description: "Harvest \(amount) \(cropType)",
            criteria: criteria,
            target: Float(amount)
        )

        let component = QuestComponent(
            title: title,
            objectives: [objective],
            order: order
        )

        return Quest(questComponent: component,
                     rewardComponents: rewards)
    }

    private static func createSurvivalQuest(
        title: String,
        days: Int,
        rewards: [RewardComponent],
        order: Int = Int.max
    ) -> Quest {

        let criteria = SurviveNumberOfTurnsCriteria()

        let objective = QuestObjective(
            description: "Survive for \(days) days",
            criteria: criteria,
            target: Float(days)
        )

        let component = QuestComponent(
            title: title,
            objectives: [objective],
            order: order
        )

        return Quest(questComponent: component,
                     rewardComponents: rewards)
    }

    private static func createSellQuest(
        title: String,
        cropType: CropType,
        amount: Int,
        rewards: [RewardComponent],
        order: Int = Int.max
    ) -> Quest {

        let criteria = SellCropCriteria(cropType: cropType)

        let objective = QuestObjective(
            description: "Sell \(amount) \(cropType) at the market",
            criteria: criteria,
            target: Float(amount)
        )

        let component = QuestComponent(
            title: title,
            objectives: [objective],
            order: order
        )

        return Quest(questComponent: component,
                     rewardComponents: rewards)
    }

    // MARK: - Multi-Objective Quests

    private static func createFarmBusinessQuest(
        cropType: CropType = .apple,
        harvestAmount: Int = 15,
        sellAmount: Int = 10,
        survivalDays: Int = 3,
        order: Int = Int.max
    ) -> Quest {
        // First objective: Harvest crops
        let harvestCriteria = HarvestCropCriteria(cropType: cropType)

        let harvestObjective = QuestObjective(
            description: "Harvest \(harvestAmount) \(cropType)",
            criteria: harvestCriteria,
            target: Float(harvestAmount)
        )

        // Second objective: Sell crops
        let sellCriteria = SellCropCriteria(cropType: cropType)

        let sellObjective = QuestObjective(
            description: "Sell \(sellAmount) \(cropType) at the market",
            criteria: sellCriteria,
            target: Float(sellAmount)
        )

        // Third objective: Survive days
        let survivalCriteria = SurviveNumberOfTurnsCriteria()

        let survivalObjective = QuestObjective(
            description: "Survive for \(survivalDays) days",
            criteria: survivalCriteria,
            target: Float(survivalDays)
        )

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

    private static func createAppleCollectionQuest(order: Int = Int.max) -> Quest {
        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 100),
            RewardCurrencyComponent(currencies: [.coin: 50])
        ]

        return createHarvestQuest(
            title: "Apple Collection",
            cropType: .apple,
            amount: 10,
            rewards: rewards,
            order: order
        )
    }

    private static func createFarmStarterQuest(order: Int = Int.max) -> Quest {
        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 50),
            RewardItemComponent(itemTypes: [.premiumFertiliser: 1])
        ]

        return createSurvivalQuest(
            title: "Farm Beginnings",
            days: 7,
            rewards: rewards,
            order: order
        )
    }

    private static func createSellQuestBakChoy(order: Int = Int.max) -> Quest {
        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 75),
            RewardCurrencyComponent(currencies: [.coin: 100])
        ]

        return createSellQuest(title: "Market sales",
                               cropType: .bokChoy,
                               amount: 8,
                               rewards: rewards,
                               order: order
        )
    }

    private static func createHarvestQuestBakChoy(order: Int = Int.max) -> Quest {
        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 25)
        ]

        return createHarvestQuest(title: "Learning to harvest",
                                  cropType: .bokChoy,
                                  amount: 3,
                                  rewards: rewards,
                                  order: order
        )

    }

    static func createAllQuests() -> [Quest] {
        [
            createFarmStarterQuest(order: 1),
            createHarvestQuestBakChoy(order: 2),
            createSellQuestBakChoy(order: 3),
            createFarmBusinessQuest(order: 4),
            createAppleCollectionQuest(order : 5)
        ]
    }

}
