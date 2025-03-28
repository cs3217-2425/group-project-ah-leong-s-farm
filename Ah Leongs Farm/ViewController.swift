//
//  ViewController.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/3/25.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    let gameManager: GameManager
    let gameRenderer: GameRenderer

    private var gameScene: GameScene?
    private var dayLabel: UILabel?

    required init?(coder: NSCoder) {
        gameManager = GameManager()
        gameRenderer = GameRenderer(gameManager: gameManager)
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGameScene()
        createQuitButton()
        createNextButton()
        createDayLabel()
    }

    private func createNextButton() {
        let nextButton = UIButton(type: .system)

        nextButton.setTitle("Next Day", for: .normal)
        nextButton.backgroundColor = .systemBlue
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 10
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.titleLabel?.font = UIFont(name: "Press Start 2P", size: 12)

        view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -130),
            nextButton.widthAnchor.constraint(equalToConstant: 140),
            nextButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        nextButton.addTarget(self, action: #selector(nextTurnButtonTapped), for: .touchUpInside)
    }

    private func createQuitButton() {
        let quitButton = UIButton(type: .system)

        quitButton.setTitle("Quit", for: .normal)
        quitButton.backgroundColor = .systemRed
        quitButton.setTitleColor(.white, for: .normal)
        quitButton.layer.cornerRadius = 10
        quitButton.translatesAutoresizingMaskIntoConstraints = false
        quitButton.titleLabel?.font = UIFont(name: "Press Start 2P", size: 12)

        view.addSubview(quitButton)
        NSLayoutConstraint.activate([
            quitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            quitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            quitButton.widthAnchor.constraint(equalToConstant: 100),
            quitButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        quitButton.addTarget(self, action: #selector(quitButtonTapped), for: .touchUpInside)
    }

    private func createDayLabel() {
        guard let turnSystem = gameManager.gameWorld.getSystem(ofType: TurnSystem.self) else {
            return
        }

        let currentTurn = turnSystem.getCurrentTurn()
        let maxTurns = turnSystem.getMaxTurns()

        let label = UILabel()
        label.textColor = .white
        label.text = "DAY \(currentTurn)/\(maxTurns)"
        label.textAlignment = .left
        label.font = UIFont(name: "Press Start 2P", size: 26)
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.widthAnchor.constraint(equalToConstant: 250),
            label.heightAnchor.constraint(equalToConstant: 40)
        ])

        self.dayLabel = label
        updateDayLabel()
    }

    private func updateDayLabel() {
        guard let turnSystem = gameManager.gameWorld.getSystem(ofType: TurnSystem.self),
              let label = dayLabel else {
            return
        }

        let currentTurn = turnSystem.getCurrentTurn()
        let maxTurns = turnSystem.getMaxTurns()
        label.text = "DAY \(currentTurn)/\(maxTurns)"
    }

    @objc func nextTurnButtonTapped() {
        gameManager.gameWorld.queueEvent(EndTurnEvent())

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateDayLabel()
        }
    }

    @objc func quitButtonTapped() {
        let alert = UIAlertController(title: "Quit Game?",
                                      message: "Are you sure you want to return to main menu?",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Quit", style: .destructive, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))

        present(alert, animated: true, completion: nil)
    }

    private func setUpGameScene() {
        guard let skView = self.view as? SKView else {
            return
        }

        self.gameScene = GameScene(size: skView.bounds.size)
        gameRenderer.setScene(gameScene)
        gameScene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        skView.presentScene(gameScene)
    }

    override var prefersStatusBarHidden: Bool {
        true
    }
}

// MARK: IGameProvider
extension ViewController: IGameProvider {
}
