//
//  GameManager+QuestDataProvider.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 3/4/25.
//

import Foundation

extension GameManager: QuestDataProvider {
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
        return sortedQuests.map { questComponent in
            QuestViewModel(
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
                isCompleted: questComponent.isCompleted
            )
        }
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
