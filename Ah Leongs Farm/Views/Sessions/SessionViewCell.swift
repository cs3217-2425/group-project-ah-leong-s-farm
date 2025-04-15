//
//  SessionViewCell.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 15/4/25.
//

import UIKit

class SessionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "SessionCell"

    weak var delegate: SessionViewCellDelegate?
    private var sessionId: UUID?

    private let label = UILabel()
    private let deleteButton = UIButton(type: .system)

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
        contentView.clipsToBounds = true

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Press Start 2P", size: 10)
        label.textColor = .systemBlue
        label.textAlignment = .left

        deleteButton.setTitle("✕", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)

        contentView.addSubview(label)
        contentView.addSubview(deleteButton)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: deleteButton.leadingAnchor, constant: -10),

            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            deleteButton.heightAnchor.constraint(equalToConstant: 30),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    @objc private func deleteTapped() {
        guard let sessionId = sessionId else {
            return
        }
        delegate?.didTapDelete(sessionId: sessionId)
    }

    func configure(with session: SessionData) {
        self.sessionId = session.id
        label.text = "Session \(session.id.uuidString.prefix(8))"
    }
}
