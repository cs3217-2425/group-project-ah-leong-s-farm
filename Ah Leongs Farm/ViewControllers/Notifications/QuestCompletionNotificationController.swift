//
//  QuestCompletionNotificationController.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 4/4/25.
//

class QuestCompletionNotificationController {

    private let notificationManager: NotificationManager

    init(notificationManager: NotificationManager) {
        self.notificationManager = notificationManager
    }

    func onQuestCompleted(_ questTitle: String) {
        notificationManager.showNotification(
            title: "Quest Completed!",
            message: "\(questTitle) is complete!"
        )
    }
}

extension QuestCompletionNotificationController: IEventObserver {
    func onEvent(_ eventData: EventData) {
        if eventData is QuestCompletedEventData {
            if let questCompletedData = eventData as? QuestCompletedEventData {
                onQuestCompleted(questCompletedData.questTitle)
            }
        }
    }
}
