//
//  ViewController.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/3/25.
//

import UIKit
import SpriteKit
import GameplayKit

class ViewController: UIViewController {
    let gameManager: GameManager
    let gameRenderer: GameRenderer

    private var gameScene: GameScene?
    private var gameControlsView: GameControlsView?
    private var gameStatisticsView: GameStatisticsView?

    required init?(coder: NSCoder) {
        gameManager = GameManager()
        gameRenderer = GameRenderer()
        super.init(coder: coder)
        setUpGameObservers()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGameScene()
        createInventoryButton()
        setUpGameControls()
        setUpGameStatistics()
        gameManager.addGameObserver(self)
    }

    private func setUpGameStatistics() {
        let gameStatistics = GameStatisticsView()
        gameStatistics.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gameStatistics)

        NSLayoutConstraint.activate([
            gameStatistics.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            gameStatistics.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])

        self.gameStatisticsView = gameStatistics
    }

    private func setUpGameControls() {
        let gameControls = GameControlsView(delegate: self)
        gameControls.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gameControls)

        NSLayoutConstraint.activate([
            gameControls.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            gameControls.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gameControls.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            gameControls.heightAnchor.constraint(equalToConstant: 80)
        ])

        self.gameControlsView = gameControls
    }

    private func setUpGameScene() {
        guard let skView = self.view as? SKView else {
            return
        }

        self.gameScene = GameScene(size: skView.bounds.size)
        gameScene?.setGameSceneUpdateDelegate(self)
        gameRenderer.setScene(gameScene)

        gameScene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        skView.presentScene(gameScene)
    }

    private func setUpGameObservers() {
        gameManager.addGameObserver(gameRenderer)
    }

    override var prefersStatusBarHidden: Bool {
        true
    }

    deinit {
        gameManager.removeGameObserver(self)
    }
}

// MARK: GameControlsViewDelegate
extension ViewController: GameControlsViewDelegate {
    func nextDayButtonTapped() {
        gameManager.nextTurn()
    }

    func quitButtonTapped() {
        let alert = UIAlertController(title: "Quit Game?",
                                      message: "Are you sure you want to return to main menu?",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Quit", style: .destructive, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))

        present(alert, animated: true, completion: nil)
    }
}

// MARK: IGameObserver
extension ViewController: IGameObserver {
    private func updateDayLabel() {
        let currentTurn = gameManager.getCurrentTurn()
        let maxTurns = gameManager.getMaxTurns()
        gameStatisticsView?.updateDayLabel(currentTurn: currentTurn, maxTurns: maxTurns)
    }

    private func updateCurrencyLabel() {
        let coins = gameManager.getAmountOfCurrency(.coin)
        gameStatisticsView?.updateCurrencyLabel(currency: coins)
    }

    private func updateEnergyLabel() {
        let currentEnergy = gameManager.getCurrentEnergy()
        let maxEnergy = gameManager.getMaxEnergy()
        gameStatisticsView?.updateEnergyLabel(currentEnergy: currentEnergy, maxEnergy: maxEnergy)
    }

    private func updateLevelLabel() {
        let currentLevel = gameManager.getCurrentLevel()
        gameStatisticsView?.updateLevelLabel(level: currentLevel)
    }

    private func updateXPLabel() {
        let currentXP = gameManager.getCurrentXP()
        let currentLevelXP = gameManager.getXPForCurrentLevel()
        gameStatisticsView?.updateXPLabel(currentXP: currentXP, levelXP: currentLevelXP)
    }

    func observe(entities: Set<GKEntity>) {
        updateDayLabel()
        updateCurrencyLabel()
        updateEnergyLabel()
        updateLevelLabel()
        updateXPLabel()
    }
}

// MARK: Add Inventory functionalities
extension ViewController {

    func createInventoryButton() {
        let inventoryButton = UIButton(type: .system)

        inventoryButton.setTitle("Inventory", for: .normal)
        inventoryButton.backgroundColor = .systemBlue
        inventoryButton.setTitleColor(.white, for: .normal)
        inventoryButton.layer.cornerRadius = 10
        inventoryButton.translatesAutoresizingMaskIntoConstraints = false

        inventoryButton.titleLabel?.font = UIFont(name: "Press Start 2P", size: 12)

        view.addSubview(inventoryButton)
        NSLayoutConstraint.activate([
            inventoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            inventoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inventoryButton.widthAnchor.constraint(equalToConstant: 120),
            inventoryButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        inventoryButton.addTarget(self, action: #selector(inventoryButtonTapped), for: .touchUpInside)
    }

    @objc func inventoryButtonTapped() {
        let inventoryItems = gameManager.getInventoryItemViewModels()

        let inventoryVC = InventoryViewController(inventoryItems: inventoryItems)
        present(inventoryVC, animated: true)

    }
}

extension ViewController: GameSceneUpdateDelegate {
    func update(_ timeInterval: TimeInterval) {
        gameManager.update(timeInterval)

        // set handler for newly added render nodes
        for renderNode in gameRenderer.allRenderNodes where renderNode.handler !== self {
            renderNode.handler = self
        }
    }
}
