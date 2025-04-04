//
//  NotificationView.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 4/4/25.
//

import UIKit
class NotificationView: UIView {
    // MARK: Properties

    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let containerView = UIView()

    weak var delegate: NotificationViewDelegate?

    // MARK: Initialization

    init(title: String, message: String) {
        super.init(frame: .zero)
        setup(title: title, message: message)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup

    private func setup(title: String, message: String) {
        // Configure container view
        containerView.backgroundColor = #colorLiteral(red: 0.9105659127, green: 0.9105659127, blue: 0.9105659127, alpha: 1)
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)

        // Configure title label
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Press Start 2p", size: 16)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)

        // Configure message label
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messageLabel)

        // Layout constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])

        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        containerView.addGestureRecognizer(tapGesture)
        containerView.isUserInteractionEnabled = true

        alpha = 0
    }

    // MARK: Actions

    @objc private func didTap() {
        dismissWithAnimation()
    }

    func dismissWithAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(translationX: 150, y: 0)
        }) { _ in
            self.delegate?.didDismissNotification(self)
            self.removeFromSuperview()
        }
    }

    func showWithAnimation() {
        transform = CGAffineTransform(translationX: 150, y: 0)
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.transform = .identity
        }
    }
}
