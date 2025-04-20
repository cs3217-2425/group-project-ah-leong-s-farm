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
                createPlantCropObjective(type: Apple.type, plantAmount: 3),
                createWaterPlotObjective(amount: 8)
            ],
            prerequisites: prereqs,
            order: 6,
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
                createHarvestCropObjective(type: Apple.type, harvestAmount: 5),
                createUseFertiliserObjective(type: Fertiliser.type, amount: 2),
                createUseFertiliserObjective(type: PremiumFertiliser.type,
                                             amount: 1)
            ],
            prerequisites: prereqs,
            order: 7,
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
                createHarvestCropObjective(type: Apple.type, harvestAmount: 20),
                createAddPlotObjective(amount: 3)
            ],
            prerequisites: prereqs,
            order: 8,
            id: id
        )

        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 200),
            RewardCurrencyComponent(currencies: [.coin: 250]),
            RewardItemComponent(itemTypes: [
                AppleSeed.type: 5,
                PremiumFertiliser.type: 2,
                SolarPanel.type: 1
            ]),
            RewardPointsComponent(amount: 2)
        ]

        return Quest(questComponent: component, rewardComponents: rewards)
    }
}
