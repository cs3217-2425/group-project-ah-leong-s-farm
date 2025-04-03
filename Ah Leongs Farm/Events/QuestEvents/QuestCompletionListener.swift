//
//  QuestCompletionListener.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 4/4/25.
//

protocol QuestCompletionListener: AnyObject {
    func onQuestCompleted(_ questTitle: String)
}
