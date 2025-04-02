//
//  ViewController+InteractionHandler.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 30/3/25.
//

import UIKit

extension ViewController: GridInteractionHandler {
    func handleGridInteraction(row: Int, column: Int) {
        let gridActionVC = GridActionViewController(
            row: row,
            column: column,
            renderer: gameRenderer,
            eventQueue: gameManager.gameWorld
        )
        gameRenderer.lightUpTile(at: row, column: column)

        // Check if there is a currently presented view controller.
        if let presentedVC = presentedViewController {
            // Dismiss the currently presented view controller before presenting the new one.
            presentedVC.dismiss(animated: false) { [weak self] in
                self?.present(gridActionVC, animated: false)
            }
            return
        }

        present(gridActionVC, animated: true)
    }
}
