//
//  PrerequisitesView.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/4/25.
//

import UIKit

class PrerequisitesView: UIView {
    private let titleLabel = UILabel()
    private let prerequisitesStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        // Setup title
        titleLabel.text = "Prerequisites"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .darkGray
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        // Setup prerequisites container
        let prerequisitesContainer = UIView()
        prerequisitesContainer.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214410186, blue: 0.9214410186, alpha: 1)
        prerequisitesContainer.layer.cornerRadius = 8
        prerequisitesContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(prerequisitesContainer)

        // Setup prerequisites stack
        prerequisitesStackView.axis = .vertical
        prerequisitesStackView.spacing = 8
        prerequisitesStackView.alignment = .leading
        prerequisitesStackView.translatesAutoresizingMaskIntoConstraints = false
        prerequisitesContainer.addSubview(prerequisitesStackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            prerequisitesContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            prerequisitesContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            prerequisitesContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            prerequisitesContainer.bottomAnchor.constraint(equalTo: bottomAnchor),

            prerequisitesStackView.topAnchor.constraint(equalTo: prerequisitesContainer.topAnchor, constant: 10),
            prerequisitesStackView.leadingAnchor.constraint(equalTo: prerequisitesContainer.leadingAnchor,
                                                            constant: 10),
            prerequisitesStackView.trailingAnchor.constraint(equalTo: prerequisitesContainer.trailingAnchor,
                                                             constant: -10),
            prerequisitesStackView.bottomAnchor.constraint(equalTo: prerequisitesContainer.bottomAnchor,
                                                           constant: -10)
        ])
    }

    func configure(with prerequisites: [PrerequisiteViewModel]) {
        // Clear existing prerequisites
        reset()

        // If no prerequisites, hide the view
        isHidden = prerequisites.isEmpty

        // Add each prerequisite to the stack
        for prerequisite in prerequisites {
            addPrerequisiteRow(text: prerequisite.displayText, isCompleted: prerequisite.isCompleted)
        }
    }

    private func addPrerequisiteRow(text: String, isCompleted: Bool) {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.spacing = 8
        rowStack.alignment = .center

        // Status icon
        let iconName = isCompleted ? "checkmark.circle.fill" : "exclamationmark.circle"
        let iconColor = isCompleted ? UIColor.systemGreen : UIColor.systemOrange

        let statusImageView = UIImageView()
        if #available(iOS 13.0, *) {
            statusImageView.image = UIImage(systemName: iconName)?.withRenderingMode(.alwaysTemplate)
        } else {
            // Fallback for earlier versions
            statusImageView.image = UIImage(named: isCompleted ? "checkmark" : "exclamation")
        }
        statusImageView.tintColor = iconColor
        statusImageView.contentMode = .scaleAspectFit
        statusImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        statusImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        // Text label
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = isCompleted ? .darkGray : .systemRed
        label.numberOfLines = 0

        rowStack.addArrangedSubview(statusImageView)
        rowStack.addArrangedSubview(label)

        prerequisitesStackView.addArrangedSubview(rowStack)
    }

    func reset() {
        prerequisitesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}
