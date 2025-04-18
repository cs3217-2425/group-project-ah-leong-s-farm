//
//  LevelUpNotificationController.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 16/4/25.
//

class LevelUpNotificationController {

    private let notificationManager: NotificationManager

    init(notificationManager: NotificationManager) {
        self.notificationManager = notificationManager
    }

    func onLevelUp(_ newLevel: Int) {
        notificationManager.showNotification(
            title: "Level Up!",
            message: "You are now level \(newLevel)!"
        )
    }
}

extension LevelUpNotificationController: IEventObserver {
    func onEvent(_ eventData: EventData) {
        if let levelUpData = eventData as? LevelUpEventData {
            onLevelUp(levelUpData.newLevel)
        }
    }
}
