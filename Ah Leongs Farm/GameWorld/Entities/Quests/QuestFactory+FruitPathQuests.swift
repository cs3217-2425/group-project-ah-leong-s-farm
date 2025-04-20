//
//  QuestFactory+FruitPathQuests.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/4/25.
//

extension QuestFactory {
    static func createOrchardKeeperQuest(id: QuestID, prereqs: [QuestID]) -> Quest {
        let component = QuestComponent(
            title: "Orchard Keeper",
            objectives: [
                createPlantCropObjective(type: AppleSeed.type, plantAmount: 3)
            ],
            prerequisites: prereqs,
            id: id
        )

        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 50),
            RewardCurrencyComponent(currencies: [.coin: 75]),
            RewardItemComponent(itemTypes: [AppleSeed.type: 2])
        ]

        return Quest(questComponent: component, rewardComponents: rewards)
    }

    static func createFruitEnthusiastQuest(id: QuestID, prereqs: [QuestID]) -> Quest {
        let component = QuestComponent(
            title: "Fruit Enthusiast",
            objectives: [
                createHarvestCropObjective(type: Apple.type, harvestAmount: 5)
            ],
            prerequisites: prereqs,
            id: id
        )

        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 100),
            RewardCurrencyComponent(currencies: [.coin: 100]),
            RewardItemComponent(itemTypes: [
                AppleSeed.type: 3,
                PremiumFertiliser.type: 1
            ])
        ]

        return Quest(questComponent: component, rewardComponents: rewards)
    }

    static func createPomologistQuest(id: QuestID, prereqs: [QuestID]) -> Quest {
        let component = QuestComponent(
            title: "Pomologist",
            objectives: [
                createSellItemObjective(type: Apple.type, sellAmount: 15),
                createHarvestCropObjective(type: Apple.type, harvestAmount: 20)
            ],
            prerequisites: prereqs,
            id: id
        )

        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 200),
            RewardCurrencyComponent(currencies: [.coin: 250]),
            RewardItemComponent(itemTypes: [
                AppleSeed.type: 5,
                PremiumFertiliser.type: 2
            ])
        ]

        return Quest(questComponent: component, rewardComponents: rewards)
    }
}
