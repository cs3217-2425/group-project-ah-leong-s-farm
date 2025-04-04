//
//  NotificationFactory.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 4/4/25.
//

class NotificationFactory {
    static func createNotification(title: String, message: String) -> NotificationView {
        NotificationView(title: title, message: message)
    }
}
