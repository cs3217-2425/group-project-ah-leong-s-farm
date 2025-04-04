//
//  GameOverViewController.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 4/4/25.
//

import UIKit

class GameOverViewController: UIViewController {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Press Start 2P", size: 32)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.text = "Game Over"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Press Start 2P", size: 20)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var coinLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Press Start 2P", size: 20)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    private func setUpView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupContainerView()
        setUpContent()
    }

    private func setupContainerView() {
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
    }

    private func setUpContent() {
        let gameStats = UIStackView(arrangedSubviews: [scoreLabel, coinLabel])
        gameStats.axis = .vertical
        gameStats.spacing = 12
        gameStats.alignment = .center
        gameStats.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [titleLabel, gameStats])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }

    private func setScore(_ score: Int) {
        scoreLabel.text = "Score: \(score)"
    }

    private func setCoins(_ coins: Double) {
        coinLabel.text = "Coins: \(coins)"
    }
}

extension GameOverViewController: IEventObserver {
    func onEvent(_ eventData: any EventData) {
        guard let eventData = eventData as? GameOverEventData else {
            return
        }
        setScore(eventData.score)
        setCoins(eventData.coins)
    }
}
