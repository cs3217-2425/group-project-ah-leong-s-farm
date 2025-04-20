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
                createWaterPlotObjective(amount: 2),
                createPlantCropObjective(type: BokChoy.type, plantAmount: 1),
                createAddPlotObjective(amount: 1)
            ],
            prerequisites: [],
            order: 1,
            id: id
        )

        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 25),
            RewardCurrencyComponent(currencies: [.coin: 25]),
            RewardItemComponent(itemTypes: [BokChoySeed.type: 2,
                                            Fertiliser.type: 1])
        ]

        return Quest(questComponent: component, rewardComponents: rewards)
    }

    static func createFarmFoundationsQuest(id: QuestID, prereqs: [QuestID]) -> Quest {
        let component = QuestComponent(
            title: "Farm Foundations",
            objectives: [
                createHarvestCropObjective(type: BokChoy.type, harvestAmount: 2),
                createUseFertiliserObjective(type: Fertiliser.type, amount: 1),
                createSellItemObjective(type: BokChoy.type, sellAmount: 1)
            ],
            prerequisites: prereqs,
            order: 2,
            id: id
        )

        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 50),
            RewardCurrencyComponent(currencies: [.coin: 50]),
            RewardItemComponent(itemTypes: [
                AppleSeed.type: 2,
                PotatoSeed.type: 2,
                Fertiliser.type: 1
            ]),
            RewardPointsComponent(amount: 1)
        ]

        return Quest(questComponent: component, rewardComponents: rewards)
    }
}
