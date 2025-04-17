//
//  GameStatisticsView.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 30/3/25.
//

import UIKit

class GameStatisticsView: UIView {
    private var dayLabel: UILabel?
    private var currencyLabel: UILabel?
    private var energyLabel: UILabel?
    private var upgradePointsLabel: UILabel?
    private var levelLabel: UILabel?
    private var progressBar: ProgressBar?
    private let XP_BAR_WIDTH = 280.0
    private let XP_BAR_HEIGHT = 30.0

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear
        let dayLabel = createDayLabel()
        let currencyLabel = createCurrencyLabel()
        let energyLabel = createEnergyLabel()
        let upgradePointsLabel = createUpgradePointsLabel()
        let levelLabel = createLevelLabel()
        let xpBar = createXPBar()

        let levelView = UIStackView(arrangedSubviews: [levelLabel, xpBar])
        levelView.spacing = 8
        levelView.alignment = .center
        levelView.translatesAutoresizingMaskIntoConstraints = false

        let usableItemsView = UIStackView(arrangedSubviews: [currencyLabel, energyLabel, upgradePointsLabel])
        usableItemsView.axis = .vertical
        usableItemsView.spacing = 8
        usableItemsView.alignment = .leading
        usableItemsView.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [dayLabel, levelView, usableItemsView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            xpBar.widthAnchor.constraint(equalToConstant: XP_BAR_WIDTH),
            xpBar.heightAnchor.constraint(equalToConstant: XP_BAR_HEIGHT)
        ])

        addSubview(stackView)
    }

    private func createDayLabel() -> UIView {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(name: "Press Start 2P", size: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.dayLabel = label

        return label
    }

    private func createCurrencyLabel() -> UIView {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Press Start 2P", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false

        let imageName = "coin"
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])

        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        self.currencyLabel = label

        return stackView
    }

    private func createEnergyLabel() -> UIView {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Press Start 2P", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false

        let imageName = "energy"
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])

        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        self.energyLabel = label

        return stackView
    }

    private func createUpgradePointsLabel() -> UIView {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Press Start 2P", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false

        let imageName = "upgrade"
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])

        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isHidden = true  // Hide by default

        self.upgradePointsLabel = label

        return stackView
    }

    private func createLevelLabel() -> UIView {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Press Start 2P", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false

        self.levelLabel = label

        return label
    }

    private func createXPBar() -> UIView {
        let progressBar = ProgressBar(frame: CGRect(x: 0, y: 0, width: XP_BAR_WIDTH, height: XP_BAR_HEIGHT))
        self.progressBar = progressBar

        return progressBar
    }

    func updateDayLabel(currentTurn: Int, maxTurns: Int) {
        dayLabel?.text = "DAY \(currentTurn)/\(maxTurns)"
    }

    func updateCurrencyLabel(currency: Double) {
        currencyLabel?.text = "\(Int(currency))"
    }

    func updateEnergyLabel(currentEnergy: Int, maxEnergy: Int) {
        energyLabel?.text = "\(currentEnergy)/\(maxEnergy)"
    }

    func updateUpgradePointsLabel(points: Int) {
        if let label = upgradePointsLabel, let stackView = label.superview as? UIStackView {
            if points > 0 {
                label.text = "\(points)"
                stackView.isHidden = false
            } else {
                stackView.isHidden = true
            }
        }
    }

    func updateLevelLabel(level: Int) {
        levelLabel?.text = "LVL.\(level)"
    }

    func updateXPLabel(currentXP: Float, levelXP: Float) {
        progressBar?.setProgress(current: CGFloat(currentXP),
                                 max: CGFloat(levelXP),
                                 label: "XP")
    }
}
