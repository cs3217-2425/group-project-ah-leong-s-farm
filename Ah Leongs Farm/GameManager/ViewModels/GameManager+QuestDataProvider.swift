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

        let allQuestComponents = questSystem.getAllQuests()
        let questComponentMap = questSystem.questComponentMap

        let filteredQuests = allQuestComponents.filter {
            $0.status == status
        }

        let sortedQuests = filteredQuests.sorted(by: {
            $0.order < $1.order
        })

        return sortedQuests.compactMap { questComponent in
            createQuestViewModel(from: questComponent, questSystem: questSystem, questMap: questComponentMap)
        }
    }

    private func createQuestViewModel(from component: QuestComponent,
                                      questSystem: QuestSystem,
                                      questMap: [QuestID: QuestComponent]) -> QuestViewModel? {
        guard let questEntity = component.ownerEntity as? Quest else {
            return nil
        }

        let rewardViewModels = processRewards(for: questEntity, using: questSystem)
        let prerequisiteViewModels = createPrerequisiteViewModels(from: component.prerequisites, using: questMap)

        return QuestViewModel(
            title: component.title,
            status: component.status,
            objectives: createObjectiveViewModels(from: component.objectives),
            isCompleted: component.isCompleted,
            rewards: rewardViewModels,
            prerequisites: prerequisiteViewModels,
            id: component.id
        )
    }

    private func processRewards(for questEntity: Quest, using questSystem: QuestSystem) -> [RewardViewModel] {
        let rewardComponents = questSystem.getAllRewardComponents(questEntity: questEntity)
        var rewardViewModels = rewardComponents.flatMap { $0.accept(visitor: self) }
        rewardViewModels.sort { $0.getIconName() < $1.getIconName() }
        return rewardViewModels
    }

    private func createPrerequisiteViewModels(from prerequisites: [QuestID],
                                              using questMap: [QuestID: QuestComponent]) -> [PrerequisiteViewModel] {
        prerequisites.compactMap { prereqId -> PrerequisiteViewModel? in
            guard let prereqComponent = questMap[prereqId] else {
                return nil
            }

            return PrerequisiteViewModel(
                id: prereqId,
                title: prereqComponent.title,
                isCompleted: prereqComponent.status == .completed
            )
        }
    }

    private func createObjectiveViewModels(from objectives: [QuestObjective]) -> [QuestObjectiveViewModel] {
        objectives.map { objective in
            QuestObjectiveViewModel(
                description: objective.description,
                progress: objective.progress,
                target: objective.target,
                isCompleted: objective.isCompleted
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

    internal func retrieveData(component: RewardPointsComponent) -> [RewardViewModel] {
        [RewardPointsViewModel(amount: component.amount)]
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
    func retrieveData(component: RewardPointsComponent) -> [RewardViewModel]
}
