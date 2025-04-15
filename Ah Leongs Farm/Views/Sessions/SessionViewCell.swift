//
//  SessionViewCell.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 15/4/25.
//

import UIKit

class SessionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "SessionCell"

    private let label = UILabel()

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
        label.textAlignment = .center
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }

    func configure(with session: SessionData) {
        label.text = "Session \(session.id.uuidString.prefix(8))"
    }
}
