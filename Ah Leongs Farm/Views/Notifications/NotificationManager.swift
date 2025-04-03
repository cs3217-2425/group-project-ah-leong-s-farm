//
//  NotificationManager.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 4/4/25.
//

protocol NotificationManager: AnyObject {
    func showNotification(title: String, message: String)
    func removeNotification(_ notification: NotificationView)
}
