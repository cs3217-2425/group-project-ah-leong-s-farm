//
//  ViewController+InteractionHandler.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 30/3/25.
//

import UIKit

extension ViewController: InteractionHandler {
    func handleInteraction(node: any IRenderNode) {
        // ignore
    }

    func handleInteraction(node: PlotSpriteNode) {
        let plotActionVC = PlotActionViewController(
            plotNode: node,
            eventQueue: gameManager.gameWorld,
            provider: gameManager
        )
        present(plotActionVC, animated: true)
    }

    func handleInteraction(node: AppleSpriteNode) {
        // not yet implemented
    }

    func handleInteraction(node: BokChoySpriteNode) {
        // not yet implemented
    }

    func handleInteraction(node: PotatoSpriteNode) {
        // not yet implemented
    }
}
