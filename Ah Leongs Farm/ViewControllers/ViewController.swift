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

    private var gameControlsView: GameControlsView?
    private var gameStatisticsView: GameStatisticsView?
    private var gameOverViewController = GameOverViewController()

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(sessionId: UUID) {
        gameManager = GameManager(sessionId: sessionId)
        gameRenderer = GameRenderer()
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .fullScreen
        setUpGameObservers()
    }

    convenience init() {
        self.init(sessionId: UUID())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGameScene()
        setUpGameControls()
        setUpGameStatistics()
        setupNotificationSystem()
        gameManager.addGameObserver(self)
        gameManager.registerEventObserver(gameOverViewController)

        // Detect when the app is backgrounded
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillResignActive),
            name: UIApplication.willResignActiveNotification, object: nil
        )
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
            gameControls.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])

        self.gameControlsView = gameControls
    }

    private func setUpGameScene() {
        loadViewIfNeeded()

        let skView = SKView(frame: view.bounds)
        self.view = skView

        let gameScene = GameScene(view: skView)
        gameScene.setGameSceneUpdateDelegate(self)
        gameScene.setUIPositionProvider(gameRenderer)
        gameScene.setGridInteractionHandler(self)
        gameRenderer.setScene(gameScene)

        gameScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        skView.presentScene(gameScene)
    }

    private func setUpGameObservers() {
        gameManager.addGameObserver(gameRenderer)
        gameManager.addGameObserver(self)
    }

    override var prefersStatusBarHidden: Bool {
        true
    }

    @objc private func appWillResignActive() {
        gameManager.saveSession()
    }
}

// MARK: GameControlsViewDelegate
extension ViewController: GameControlsViewDelegate {
    func nextDayButtonTapped() {
        let currentTurn = gameManager.getCurrentTurn()
        let maxTurn = gameManager.getMaxTurns()

        if currentTurn == maxTurn {
            present(gameOverViewController, animated: true)
        }

        gameManager.nextTurn()
    }

    func quitButtonTapped() {
        let alert = UIAlertController(title: "Quit Game?",
                                      message: "Are you sure you want to return to main menu?",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Quit", style: .destructive, handler: { _ in
            // removes strong cyclic reference between game manager and view controller
            self.gameManager.removeGameObserver(self)
            self.gameManager.stopSounds()
            self.gameManager.saveSession()
            self.dismiss(animated: true, completion: nil)
        }))

        present(alert, animated: true, completion: nil)
    }

    func marketButtonTapped() {
        let marketViewController = MarketViewController(marketDataHandler: gameManager)
        gameManager.addGameObserver(marketViewController)
        marketViewController.modalPresentationStyle = .formSheet
        marketViewController.preferredContentSize = CGSize(
            width: view.bounds.width * 0.8,
            height: view.bounds.height * 0.75
        )
        present(marketViewController, animated: true)
    }

    @objc func inventoryButtonTapped() {
        let inventoryItems = gameManager.getInventoryItemViewModels()

        let inventoryVC = InventoryViewController(inventoryItems: inventoryItems)
        present(inventoryVC, animated: true)

    }

    @objc func questButtonTapped() {
        let activeQuests = gameManager.getActiveQuestViewModels()
        let completedQuests = gameManager.getCompletedQuestViewModels()
        let inactiveQuests = gameManager.getInactiveQuestViewModels()

        let questVC = QuestViewController(activeQuests: activeQuests,
                                          completedQuests: completedQuests,
                                          inactiveQuests: inactiveQuests)
        present(questVC, animated: true)
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
        let currentEnergy = gameManager.getCurrentEnergy(of: .base)
        let maxEnergy = gameManager.getMaxEnergy(of: .base)
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

    private func updateUpgradePointsLabel() {
        let upgradePoints = gameManager.getCurrentUpgradePoints()
        gameStatisticsView?.updateUpgradePointsLabel(points: upgradePoints)
    }

    func observe(entities: [Entity]) {
        updateDayLabel()
        updateCurrencyLabel()
        updateEnergyLabel()
        updateLevelLabel()
        updateXPLabel()
        updateUpgradePointsLabel()
    }
}

extension ViewController: GameSceneUpdateDelegate {
    func update(_ timeInterval: TimeInterval) {
        gameManager.update(timeInterval)

        // set handler for newly added render nodes
        for renderNode in gameRenderer.allRenderNodes {
            acceptIntoTouchHandlerRegistry(node: renderNode)
        }
    }
}

// MARK: Add Notification functionalities
extension ViewController {
    func setupNotificationSystem() {
        let notificationManager = NotificationStackManager(
            containerView: self.view,
            topOffset: 100 // Position below the game controls
        )

        let questNotificationController = QuestCompletionNotificationController(
            notificationManager: notificationManager
        )

        let levelUpNotificationController = LevelUpNotificationController(
            notificationManager: notificationManager
        )

        let harvestNotificationController = HarvestCropNotificationController(
            notificationManager: notificationManager
        )

        let errorNotificationController = ErrorNotificationController(
            notificationManager: notificationManager
        )

        gameManager.registerEventObserver(questNotificationController)
        gameManager.registerEventObserver(levelUpNotificationController)
        gameManager.registerEventObserver(harvestNotificationController)
        gameManager.registerEventObserver(errorNotificationController)
    }
}
