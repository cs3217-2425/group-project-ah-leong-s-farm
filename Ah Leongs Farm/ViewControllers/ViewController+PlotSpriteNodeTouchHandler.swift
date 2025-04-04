//
//  ViewController+PlotSpriteNodeTouchHandler.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 2/4/25.
//

extension ViewController: PlotSpriteNodeTouchHandler {
    func handleTouch(node: PlotSpriteNode) {
        let plotActionVC = PlotActionViewController(
            plotNode: node,
            eventQueue: gameManager.gameWorld,
            provider: gameManager
        )
        present(plotActionVC, animated: true)
    }
}
