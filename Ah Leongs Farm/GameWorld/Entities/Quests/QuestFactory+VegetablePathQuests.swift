//
//  QuestFactory+VegetablePathQuests.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/4/25.
//

extension QuestFactory {
    static func createVegetableApprenticeQuest(id: QuestID, prereqs: [QuestID]) -> Quest {
        let component = QuestComponent(
            title: "Vegetable Apprentice",
            objectives: [
                createPlantCropObjective(type: PotatoSeed.type, plantAmount: 3),
                createPlantCropObjective(type: BokChoySeed.type, plantAmount: 3)
            ],
            prerequisites: prereqs,
            id: id
        )

        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 75),
            RewardCurrencyComponent(currencies: [.coin: 60]),
            RewardItemComponent(itemTypes: [Fertiliser.type: 2])
        ]

        return Quest(questComponent: component, rewardComponents: rewards)
    }

    static func createGreenThumbQuest(id: QuestID, prereqs: [QuestID]) -> Quest {
        let component = QuestComponent(
            title: "Green Thumb",
            objectives: [
                createHarvestCropObjective(type: Potato.type, harvestAmount: 5),
                createHarvestCropObjective(type: BokChoy.type, harvestAmount: 8)
            ],
            prerequisites: prereqs,
            id: id
        )

        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 100),
            RewardCurrencyComponent(currencies: [.coin: 100]),
            RewardItemComponent(itemTypes: [
                PotatoSeed.type: 3,
                BokChoySeed.type: 3,
                PremiumFertiliser.type: 1
            ])
        ]

        return Quest(questComponent: component, rewardComponents: rewards)
    }

    static func createVegetableMasterQuest(id: QuestID, prereqs: [QuestID]) -> Quest {
        let component = QuestComponent(
            title: "Vegetable Master",
            objectives: [
                createSellItemObjective(type: Potato.type, sellAmount: 10),
                createSellItemObjective(type: BokChoy.type, sellAmount: 15)
            ],
            prerequisites: prereqs,
            id: id
        )

        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 150),
            RewardCurrencyComponent(currencies: [.coin: 200]),
            RewardItemComponent(itemTypes: [
                PremiumFertiliser.type: 2,
                SolarPanel.type: 1
            ])
        ]

        return Quest(questComponent: component, rewardComponents: rewards)
    }
}
