//
//  QuestFactory+MasteryQuests.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/4/25.
//

extension QuestFactory {
    static func createSustainableFarmingQuest(id: QuestID, prereqs: [QuestID]) -> Quest {
        let component = QuestComponent(
            title: "Sustainable Farming",
            objectives: [
                createHarvestCropObjective(type: BokChoy.type, harvestAmount: 20),
                createHarvestCropObjective(type: Potato.type, harvestAmount: 15),
                createSurvivalObjective(days: 20)
            ],
            prerequisites: prereqs,
            id: id
        )

        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 250),
            RewardCurrencyComponent(currencies: [.coin: 350]),
            RewardItemComponent(itemTypes: [
                SolarPanel.type: 2,
                PremiumFertiliser.type: 3,
                PotatoSeed.type: 10,
                BokChoySeed.type: 10
            ])
        ]

        return Quest(questComponent: component, rewardComponents: rewards)
    }

    static func createFarmEmpireQuest(id: QuestID, prereqs: [QuestID]) -> Quest {
        let component = QuestComponent(
            title: "Farm Empire",
            objectives: [
                createSellItemObjective(type: Apple.type, sellAmount: 25),
                createSellItemObjective(type: Potato.type, sellAmount: 25),
                createSellItemObjective(type: BokChoy.type, sellAmount: 25)
            ],
            prerequisites: prereqs,
            id: id
        )

        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 300),
            RewardCurrencyComponent(currencies: [.coin: 500]),
            RewardItemComponent(itemTypes: [
                AppleSeed.type: 10,
                PotatoSeed.type: 10,
                BokChoySeed.type: 10,
                PremiumFertiliser.type: 5
            ])
        ]

        return Quest(questComponent: component, rewardComponents: rewards)
    }

    static func createAgriculturalLegendQuest(id: QuestID, prereqs: [QuestID]) -> Quest {
        let component = QuestComponent(
            title: "Agricultural Legend",
            objectives: [
                createSurvivalObjective(days: 25),
                createHarvestCropObjective(type: Apple.type, harvestAmount: 30),
                createHarvestCropObjective(type: Potato.type, harvestAmount: 30),
                createHarvestCropObjective(type: BokChoy.type, harvestAmount: 30)
            ],
            prerequisites: prereqs,
            id: id
        )

        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 500),
            RewardCurrencyComponent(currencies: [.coin: 1000]),
            RewardItemComponent(itemTypes: [
                AppleSeed.type: 15,
                PotatoSeed.type: 15,
                BokChoySeed.type: 15,
                PremiumFertiliser.type: 10,
                SolarPanel.type: 3
            ])
        ]

        return Quest(questComponent: component, rewardComponents: rewards)
    }
}
