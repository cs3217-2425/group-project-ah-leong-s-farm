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
    private var levelLabel: UILabel?
    private var progressBar: LevelProgressBar?

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
        createDayLabel()
        createCurrencyLabel()
        createEnergyLabel()
        createLevelLabel()
        createXPBar()
    }

    private func createDayLabel() {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(name: "Press Start 2P", size: 26)
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])

        self.dayLabel = label
    }

    private func createCurrencyLabel() {
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

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 100)
        ])

        self.currencyLabel = label
    }

    private func createEnergyLabel() {
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

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 132)
        ])

        self.energyLabel = label
    }

    private func createLevelLabel() {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Press Start 2P", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 44)
        ])

        self.levelLabel = label
    }

    private func createXPBar() {
        let progressBar = LevelProgressBar(frame: CGRect(x: 0, y: 68, width: 300, height: 32))
        addSubview(progressBar)

        self.progressBar = progressBar
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

    func updateLevelLabel(level: Int) {
        levelLabel?.text = "Level \(level)"
    }

    func updateXPLabel(currentXP: Float, levelXP: Float) {
        progressBar?.setProgress(currentProgress: CGFloat(currentXP), maxProgress: CGFloat(levelXP))
    }
}
