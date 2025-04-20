//
//  QuestFactory+TutorialPathQuests.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/4/25.
//

extension QuestFactory {
    static func createFirstStepsQuest(id: QuestID) -> Quest {
        let component = QuestComponent(
            title: "First Steps",
            objectives: [
                createSurvivalObjective(days: 2),
                createPlantCropObjective(type: BokChoySeed.type, plantAmount: 1)
            ],
            prerequisites: [],
            id: id
        )

        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 25),
            RewardCurrencyComponent(currencies: [.coin: 25]),
            RewardItemComponent(itemTypes: [BokChoySeed.type: 2])
        ]

        return Quest(questComponent: component, rewardComponents: rewards)
    }

    static func createFarmFoundationsQuest(id: QuestID, prereqs: [QuestID]) -> Quest {
        let component = QuestComponent(
            title: "Farm Foundations",
            objectives: [
                createHarvestCropObjective(type: BokChoy.type, harvestAmount: 2),
                createSellItemObjective(type: BokChoy.type, sellAmount: 1)
            ],
            prerequisites: prereqs,
            id: id
        )

        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 50),
            RewardCurrencyComponent(currencies: [.coin: 50]),
            RewardItemComponent(itemTypes: [
                AppleSeed.type: 2,
                PotatoSeed.type: 2,
                Fertiliser.type: 1
            ])
        ]

        return Quest(questComponent: component, rewardComponents: rewards)
    }
}
