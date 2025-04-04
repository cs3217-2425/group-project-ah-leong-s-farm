//
//  RewardsView.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 4/4/25.
//

import UIKit
class RewardsView: UIView {
    private let titleLabel = UILabel()
    private let rewardsStackView = UIStackView()

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
        titleLabel.text = "Rewards"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .darkGray
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        // Setup rewards container
        let rewardsContainer = UIView()
        rewardsContainer.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214410186, blue: 0.9214410186, alpha: 1)
        rewardsContainer.layer.cornerRadius = 8
        rewardsContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rewardsContainer)

        // Setup rewards stack
        rewardsStackView.axis = .vertical
        rewardsStackView.spacing = 8
        rewardsStackView.alignment = .leading
        rewardsStackView.translatesAutoresizingMaskIntoConstraints = false
        rewardsContainer.addSubview(rewardsStackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            rewardsContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            rewardsContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            rewardsContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            rewardsContainer.bottomAnchor.constraint(equalTo: bottomAnchor),

            rewardsStackView.topAnchor.constraint(equalTo: rewardsContainer.topAnchor, constant: 10),
            rewardsStackView.leadingAnchor.constraint(equalTo: rewardsContainer.leadingAnchor, constant: 10),
            rewardsStackView.trailingAnchor.constraint(equalTo: rewardsContainer.trailingAnchor, constant: -10),
            rewardsStackView.bottomAnchor.constraint(equalTo: rewardsContainer.bottomAnchor, constant: -10)
        ])
    }

    func configure(with rewards: [RewardViewModel]) {
        // Clear existing rewards
        reset()

        // If no rewards, hide the view
        isHidden = rewards.isEmpty

        // Add each reward to the stack
        for reward in rewards {
            addRewardRow(iconName: reward.getIconName(), text: reward.getDisplayText())
        }
    }

    private func addRewardRow(iconName: String, text: String) {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.spacing = 8
        rowStack.alignment = .center

        // Image view
        let imageView = UIImageView(image: UIImage(named: iconName))
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        // Text label
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray

        rowStack.addArrangedSubview(imageView)
        rowStack.addArrangedSubview(label)

        rewardsStackView.addArrangedSubview(rowStack)
    }

    func reset() {
        rewardsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}
