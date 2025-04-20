//
//  QuestFactory+MarketPathQuests.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/4/25.
//

extension QuestFactory {
    static func createMarketNoviceQuest(id: QuestID, prereqs: [QuestID]) -> Quest {
        let component = QuestComponent(
            title: "Market Novice",
            objectives: [
                createSellItemObjective(type: Apple.type, sellAmount: 3),
                createSellItemObjective(type: BokChoy.type, sellAmount: 3)
            ],
            prerequisites: prereqs,
            id: id
        )

        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 75),
            RewardCurrencyComponent(currencies: [.coin: 100])
        ]

        return Quest(questComponent: component, rewardComponents: rewards)
    }

    static func createMarketTraderQuest(id: QuestID, prereqs: [QuestID]) -> Quest {
        let component = QuestComponent(
            title: "Market Trader",
            objectives: [
                createSellItemObjective(type: Apple.type, sellAmount: 10),
                createSellItemObjective(type: Potato.type, sellAmount: 5),
                createSellItemObjective(type: BokChoy.type, sellAmount: 5)
            ],
            prerequisites: prereqs,
            id: id
        )

        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 125),
            RewardCurrencyComponent(currencies: [.coin: 150]),
            RewardItemComponent(itemTypes: [Fertiliser.type: 3])
        ]

        return Quest(questComponent: component, rewardComponents: rewards)
    }

    static func createMarketMogulQuest(id: QuestID, prereqs: [QuestID]) -> Quest {
        let component = QuestComponent(
            title: "Market Mogul",
            objectives: [
                createSellItemObjective(type: Apple.type, sellAmount: 20),
                createSellItemObjective(type: Potato.type, sellAmount: 15),
                createSellItemObjective(type: BokChoy.type, sellAmount: 15)
            ],
            prerequisites: prereqs,
            id: id
        )

        let rewards: [RewardComponent] = [
            RewardXPComponent(amount: 200),
            RewardCurrencyComponent(currencies: [.coin: 300]),
            RewardItemComponent(itemTypes: [
                AppleSeed.type: 5,
                PotatoSeed.type: 5,
                BokChoySeed.type: 5
            ])
        ]

        return Quest(questComponent: component, rewardComponents: rewards)
    }
}
