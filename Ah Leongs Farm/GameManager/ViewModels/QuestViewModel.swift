//
//  QuestViewModel.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 3/4/25.
//

import Foundation

struct QuestObjectiveViewModel {
    let description: String
    let progress: Float
    let target: Float
    let isCompleted: Bool
}

protocol RewardViewModel {
    func getDisplayText() -> String
    func getIconName() -> String
}

struct RewardXPViewModel: RewardViewModel {
    var xpAmount: Float
    func getDisplayText() -> String {
        "\(Int(xpAmount)) XP"
    }

    func getIconName() -> String {
        "xp"
    }
}

struct RewardCurrencyViewModel: RewardViewModel {
    let currencyType: CurrencyType
    let amount: Double
    func getDisplayText() -> String {
        "\(Int(amount)) \(currencyType)"
    }

    func getIconName() -> String {
        "coin"
    }
}

struct RewardItemViewModel: RewardViewModel {
    let itemType: ItemTypeNew
    let quantity: Int

    func getDisplayText() -> String {
        guard let name = ItemToViewDataMap.itemTypeToDisplayName[itemType] else {
            return "\(quantity) items"
        }
        return "\(quantity) × \(name)"
    }

    func getIconName() -> String {
        if let imageName = ItemToViewDataMap.itemTypeToImage[itemType] {
            return imageName
        } else {
            return "item"
        }
    }
}

struct QuestViewModel {
    let title: String
    let status: QuestStatus
    let objectives: [QuestObjectiveViewModel]
    let isCompleted: Bool
    let rewards: [RewardViewModel]
}

protocol QuestDataProvider {
    func getActiveQuestViewModels() -> [QuestViewModel]
    func getCompletedQuestViewModels() -> [QuestViewModel]
}
