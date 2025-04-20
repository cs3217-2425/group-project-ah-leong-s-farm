//
//  ErrorNotificationController.swift
//  Ah Leongs Farm
//
//  Created by proglab on 19/4/25.
//

class ErrorNotificationController {

    private let notificationManager: NotificationManager

    init(notificationManager: NotificationManager) {
        self.notificationManager = notificationManager
    }

    func onError(_ title: String, _ message: String) {
        notificationManager.showNotification(
            title: "\(title)❗️",
            message: "\(message)"
        )
    }
}

extension ErrorNotificationController: IEventObserver {
    func onEvent(_ eventData: EventData) {
        if let errorData = eventData as? ErrorEventData {
            onError(errorData.title, errorData.message)
        }
    }
}
