//
//  GameManager+QuestDataProvider.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 3/4/25.
//

import Foundation

extension GameManager: QuestDataProvider, RewardDataRetrievalVisitor {
    private func getQuestViewModels(status: QuestStatus) -> [QuestViewModel] {
        guard let questSystem = gameWorld.getSystem(ofType: QuestSystem.self) else {
            return []
        }
        let filteredQuests = questSystem.getAllQuests().filter({
            $0.status == status
        })
        let sortedQuests = filteredQuests.sorted(by: {
            $0.order < $1.order
        })
        return sortedQuests.compactMap { questComponent in
            guard let questEntity = questComponent.ownerEntity as? Quest else {
                return nil
            }
            let rewardComponents = questSystem.getAllRewardComponents(questEntity: questEntity)
            var rewardViewModels = rewardComponents.flatMap { $0.accept(visitor: self) }
            rewardViewModels.sort(by: {
                $0.getIconName() < $1.getIconName()
            })

            return QuestViewModel(
                title: questComponent.title,
                status: questComponent.status,
                objectives: questComponent.objectives.map { objective in
                    QuestObjectiveViewModel(
                        description: objective.description,
                        progress: objective.progress,
                        target: objective.target,
                        isCompleted: objective.isCompleted
                    )
                },
                isCompleted: questComponent.isCompleted,
                rewards: rewardViewModels
            )
        }
    }

    internal func retrieveData(component: RewardXPComponent) -> [RewardViewModel] {
        [RewardXPViewModel(xpAmount: component.amount)]
    }

    internal func retrieveData(component: RewardCurrencyComponent) -> [RewardViewModel] {
        var viewModels: [RewardViewModel] = []
        for (currencyType, amount) in component.currencies {
            viewModels.append(RewardCurrencyViewModel(currencyType: currencyType, amount: amount))
        }
        return viewModels
    }

    internal func retrieveData(component: RewardItemComponent) -> [RewardViewModel] {
        var viewModels: [RewardViewModel] = []
        for (itemType, quantity) in component.itemTypes {
            viewModels.append(RewardItemViewModel(itemType: itemType, quantity: quantity))
        }
        return viewModels
    }

    func getActiveQuestViewModels() -> [QuestViewModel] {
        getQuestViewModels(status: .active)
    }

    func getCompletedQuestViewModels() -> [QuestViewModel] {
        getQuestViewModels(status: .completed)
    }

    func getInactiveQuestViewModels() -> [QuestViewModel] {
        getQuestViewModels(status: .inactive)
    }
}

protocol RewardDataRetrievalVisitor {
    func retrieveData(component: RewardXPComponent) -> [RewardViewModel]
    func retrieveData(component: RewardCurrencyComponent) -> [RewardViewModel]
    func retrieveData(component: RewardItemComponent) -> [RewardViewModel]
}
