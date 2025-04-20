//
//  QuestFactory+TechnologyPathQuests.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/4/25.
//

extension QuestFactory {

    static func createTechPioneerQuest(id: QuestID, prereqs: [QuestID]) -> Quest {
        let component = QuestComponent(
            title: "Tech Pioneer",
            objectives: [
                createAddPlotObjective(amount: 1),
                createAddSolarPanelObjective(amount: 2),
                createSurvivalObjective(days: 8)
            ],
            prerequisites: prereqs,
            order: 12,
            id: id
        )

        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 75),
            RewardCurrencyComponent(currencies: [.coin: 120]),
            RewardItemComponent(itemTypes: [SolarPanel.type: 1])
        ]

        return Quest(questComponent: component, rewardComponents: rewards)
    }

    static func createSolarFarmerQuest(id: QuestID, prereqs: [QuestID]) -> Quest {
        let component = QuestComponent(
            title: "Solar Farmer",
            objectives: [
                createAddSolarPanelObjective(amount: 3),
                createAddPlotObjective(amount: 4)
            ],
            prerequisites: prereqs,
            order: 13,
            id: id
        )

        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 125),
            RewardCurrencyComponent(currencies: [.coin: 175]),
            RewardItemComponent(itemTypes: [
                SolarPanel.type: 2,
                PremiumFertiliser.type: 2
            ]),
            RewardPointsComponent(amount: 5)
        ]

        return Quest(questComponent: component, rewardComponents: rewards)
    }

}
