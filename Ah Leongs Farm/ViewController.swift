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
        gameRenderer = GameRenderer(gameManager: gameManager)
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        setUpGameScene()
    }

    private func setUpGameScene() {
        guard let skView = self.view as? SKView else {
            return
        }

        self.gameScene = GameScene(size: skView.bounds.size)
        gameRenderer.setScene(gameScene)
        gameScene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        skView.presentScene(gameScene)

        let plotRenderNodes: [PlotSpriteNode] = gameRenderer.getSKNodes(ofType: PlotSpriteNode.self)
        for plotRenderNode in plotRenderNodes {
            plotRenderNode.interactionDelegate = self
        }
    }
}

// MARK: IGameProvider
extension ViewController: IGameProvider {
}
