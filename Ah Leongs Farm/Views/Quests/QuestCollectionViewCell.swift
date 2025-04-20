//
//  QuestCollectionViewCell.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 4/4/25.
//

import UIKit
class QuestCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private let titleLabel = UILabel()
    private let statusBadge = UILabel()
    private var objectiveViews: [ObjectiveView] = []
    private let rewardsView = RewardsView()
    private let prerequisitesView = PrerequisitesView()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    func configure(with quest: QuestViewModel) {
        titleLabel.text = quest.title

        // Configure status badge
        let statusToUI: [QuestStatus: (text: String, color: UIColor)] = [
            .active: (text: "Active", color: UIColor.systemBlue),
            .inactive: (text: "Inactive", color: UIColor.lightGray),
            .completed: (text: "Completed", color: UIColor.systemGreen)
        ]
        statusBadge.text = statusToUI[quest.status]?.text
        statusBadge.backgroundColor = statusToUI[quest.status]?.color

        // Configure objectives
        configureObjectives(with: quest.objectives)

        prerequisitesView.configure(with: quest.prerequisites)

        // Configure rewards
        rewardsView.configure(with: quest.rewards)
    }

    private func configureObjectives(with objectives: [QuestObjectiveViewModel]) {
        // Clear existing objective views
        objectiveViews.forEach { $0.removeFromSuperview() }
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        objectiveViews.removeAll()

        // Add new objectives
        for objective in objectives {
            let objectiveView = ObjectiveView()
            objectiveView.configure(with: objective)
            contentStackView.addArrangedSubview(objectiveView)
            objectiveViews.append(objectiveView)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        statusBadge.text = nil
        objectiveViews.forEach { $0.removeFromSuperview() }
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        objectiveViews.removeAll()
        rewardsView.reset()
    }

    // MARK: - UI Setup
    private func setupViews() {
        backgroundColor = .clear

        let cardView = setupCardView()
        setupScrollView(in: cardView)
        setupStatusBadge(in: cardView)
        setupTitleLabel()
        setupContentStackView()
        setupPrerequisitesView()
        setupRewardsView()
        setupConstraints(cardView: cardView)
    }

    private func setupPrerequisitesView() {
        prerequisitesView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(prerequisitesView)
    }

    private func setupCardView() -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
        cardView.layer.cornerRadius = 12
        cardView.layer.borderWidth = 2
        cardView.layer.borderColor = UIColor.darkGray.cgColor
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)
        return cardView
    }

    private func setupScrollView(in containerView: UIView) {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        containerView.addSubview(scrollView)
    }

    private func setupStatusBadge(in containerView: UIView) {
        statusBadge.font = UIFont.boldSystemFont(ofSize: 12)
        statusBadge.textColor = .white
        statusBadge.layer.cornerRadius = 8
        statusBadge.clipsToBounds = true
        statusBadge.textAlignment = .center
        statusBadge.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(statusBadge)
    }

    private func setupTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(titleLabel)
    }

    private func setupContentStackView() {
        contentStackView.axis = .vertical
        contentStackView.spacing = 10
        contentStackView.distribution = .fillProportionally
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStackView)
    }

    private func setupRewardsView() {
        rewardsView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(rewardsView)
    }

    private func setupConstraints(cardView: UIView) {
        NSLayoutConstraint.activate([
            // Card view constraints
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            // Status badge constraints
            statusBadge.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            statusBadge.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            statusBadge.widthAnchor.constraint(equalToConstant: 70),
            statusBadge.heightAnchor.constraint(equalToConstant: 20),

            // Scroll view constraints
            scrollView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            scrollView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8),

            // Title label constraints
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8),

            // Content stack view constraints for objectives
            contentStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -16),

            // Prerequisites view constraints - after objectives, before rewards
            prerequisitesView.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 16),
            prerequisitesView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            prerequisitesView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8),

            // Rewards view constraints - now after prerequisites
            rewardsView.topAnchor.constraint(equalTo: prerequisitesView.bottomAnchor, constant: 16),
            rewardsView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            rewardsView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8),
            rewardsView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -12)
        ])
    }
}
