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

struct QuestViewModel {
    let title: String
    let status: QuestStatus
    let objectives: [QuestObjectiveViewModel]
    let isCompleted: Bool
}

protocol QuestDataProvider {
    func getActiveQuestViewModels() -> [QuestViewModel]
    func getCompletedQuestViewModels() -> [QuestViewModel]
}
