//
//  ObjectiveView.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 4/4/25.
//

import UIKit
class ObjectiveView: UIView {
    private let descriptionLabel = UILabel()
    private let progressBar = ProgressBar()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        // Description label
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionLabel)

        // Progress bar
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressBar)

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            progressBar.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 24),
            progressBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }

    func configure(with objective: QuestObjectiveViewModel) {
        descriptionLabel.text = objective.description

        // Calculate current and max progress values
        let currentProgress = CGFloat(objective.progress)
        let maxProgress = CGFloat(objective.target)

        progressBar.setProgress(currentProgress: currentProgress,
                                maxProgress: maxProgress,
                                label: "")
    }
}
