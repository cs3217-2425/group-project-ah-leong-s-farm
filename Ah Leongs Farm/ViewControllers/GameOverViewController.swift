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

    private var mainMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Main Menu", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "Press Start 2P", size: 14)

        return button
    }()

    private var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue Game", for: .normal)
        button.backgroundColor = .systemGray2
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "Press Start 2P", size: 14)

        return button
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
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])
    }

    private func setUpContent() {
        let gameStats = UIStackView(arrangedSubviews: [scoreLabel, coinLabel])
        gameStats.axis = .vertical
        gameStats.spacing = 12
        gameStats.alignment = .center
        gameStats.translatesAutoresizingMaskIntoConstraints = false

        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        mainMenuButton.addTarget(self, action: #selector(mainMenuButtonTapped), for: .touchUpInside)

        let buttons = UIStackView(arrangedSubviews: [continueButton, mainMenuButton])
        buttons.axis = .vertical
        buttons.spacing = 8
        buttons.alignment = .center
        buttons.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [titleLabel, gameStats, buttons])
        stackView.axis = .vertical
        stackView.spacing = 36
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            mainMenuButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            mainMenuButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            mainMenuButton.heightAnchor.constraint(equalToConstant: 40),
            continueButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc private func mainMenuButtonTapped() {
        dismiss(animated: true, completion: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    @objc private func continueButtonTapped() {
        dismiss(animated: true, completion: nil)
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
