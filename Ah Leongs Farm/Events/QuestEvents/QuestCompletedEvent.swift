//
//  QuestCompletedEvent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/3/25.
//

class QuestCompletedEvent: GameEvent {
    private let questTitle: String

    init(questTitle: String) {
        self.questTitle = questTitle
    }

    func execute(in context: EventContext, queueable: EventQueueable) -> EventData? {
        QuestCompletedEventData(questTitle: questTitle)
    }
}
