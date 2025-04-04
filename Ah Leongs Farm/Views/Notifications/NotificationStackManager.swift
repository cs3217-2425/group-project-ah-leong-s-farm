//
//  NotificationStackManager.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 4/4/25.
//

import UIKit

class NotificationStackManager: NotificationManager, NotificationViewDelegate {
    // MARK: Properties

    private weak var containerView: UIView?
    private var notifications: [NotificationView] = []
    private let notificationWidth: CGFloat = 300
    private let notificationHeight: CGFloat = 100
    private let topOffset: CGFloat

    // MARK: Initialization

    init(containerView: UIView,
         topOffset: CGFloat = 80) {
        self.containerView = containerView
        self.topOffset = topOffset
    }

    // MARK: NotificationManager

    func showNotification(title: String, message: String) {
        guard let containerView = containerView else {
            return
        }

        let notification = NotificationFactory.createNotification(title: title, message: message)
        notification.delegate = self
        notifications.append(notification)

        containerView.addSubview(notification)
        notification.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            notification.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            notification.widthAnchor.constraint(equalToConstant: notificationWidth),
            notification.heightAnchor.constraint(equalToConstant: notificationHeight)
        ])

        updateNotificationPositions()
        notification.showWithAnimation()

        // Auto-dismiss after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self, weak notification] in
            guard let self = self, let notification = notification else {
                return
            }
            if self.notifications.contains(where: { $0 === notification }) {
                notification.dismissWithAnimation()
            }
        }

    }

    func removeNotification(_ notification: NotificationView) {
        notifications.removeAll { $0 === notification }
        updateNotificationPositions()
    }

    // MARK: NotificationViewDelegate

    func didDismissNotification(_ notification: NotificationView) {
        removeNotification(notification)
    }

    // MARK: Private

    private func updateNotificationPositions() {
        guard let containerView = containerView else {
            return
        }

        for (index, notification) in notifications.enumerated() {
            // Update constraints for each notification
            let topConstant = topOffset + CGFloat(index * (Int(notificationHeight) + 10))

            // Remove existing constraints
            containerView.constraints.forEach { constraint in
                if constraint.firstItem === notification && constraint.firstAttribute == .top {
                    containerView.removeConstraint(constraint)
                }
            }

            // Add new constraint
            let topConstraint = notification.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: topConstant
            )
            topConstraint.isActive = true
        }
    }
}
