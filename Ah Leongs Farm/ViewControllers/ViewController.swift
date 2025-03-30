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

    required init?(coder: NSCoder) {
        gameManager = GameManager()
        gameRenderer = GameRenderer()
        super.init(coder: coder)
        setUpGameObservers()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGameScene()
        createQuitButton()
        createInventoryButton()
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
}

// MARK: IGameProvider
extension ViewController: IGameProvider {
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
    }
}
