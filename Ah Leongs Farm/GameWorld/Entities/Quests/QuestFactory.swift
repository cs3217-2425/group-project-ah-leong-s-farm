//
//  QuestFactory.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 21/3/25.
//

import GameplayKit

class QuestFactory {
    // MARK: - Basic Quest Creation

    static func createBasicQuest(
        title: String,
        objectives: [QuestObjective],
        reward: Reward
    ) -> Quest {
        let component = QuestComponent(
            title: title,
            objectives: objectives,
            reward: reward
        )

        return Quest(questComponent: component)
    }

    // MARK: - Standard Quest Types

    static func createHarvestQuest(
        title: String,
        cropType: CropType,
        amount: Int,
        reward: Reward
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
            reward: reward
        )

        return Quest(questComponent: component)
    }

    static func createSurvivalQuest(
        title: String,
        days: Int,
        reward: Reward
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
            reward: reward
        )

        return Quest(questComponent: component)
    }

    static func createSellQuest(
        title: String,
        cropType: CropType,
        amount: Int,
        reward: Reward
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
            reward: reward
        )

        return Quest(questComponent: component)
    }

    // MARK: - Multi-Objective Quests

    static func createFarmBusinessQuest(
        reward: Reward,
        cropType: CropType = .apple,
        harvestAmount: Int = 15,
        sellAmount: Int = 10,
        survivalDays: Int = 3
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

        // Create the quest with all objectives
        let title = "\(cropType.rawValue.capitalized) Business Venture"

        let component = QuestComponent(
            title: title,
            objectives: [harvestObjective, sellObjective, survivalObjective],
            reward: reward
        )

        return Quest(questComponent: component)
    }

    // MARK: - Utility Methods

    static func createAppleCollectionQuest() -> Quest {
        let reward = Reward(rewards: [
            XPSpecificReward(amount: 100),
            CurrencySpecificReward(currencies: [CurrencyType.coin: 50])
        ])

        return createHarvestQuest(
            title: "Apple Collection",
            cropType: .apple,
            amount: 10,
            reward: reward
        )
    }

    static func createFarmStarterQuest() -> Quest {
        let reward = Reward(rewards: [
            XPSpecificReward(amount: 50),
            ItemSpecificReward(itemTypes: [ItemType.premiumFertiliser: 1])
        ])

        return createSurvivalQuest(
            title: "Farm Beginnings",
            days: 7,
            reward: reward
        )
    }
}
