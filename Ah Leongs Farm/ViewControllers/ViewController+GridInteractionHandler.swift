//
//  ViewController+InteractionHandler.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 30/3/25.
//

import UIKit

extension ViewController: GridInteractionHandler {
    func handleGridInteraction(row: Int, column: Int) {
        let gridViewModel = gameManager.getGridViewModel(row: row, column: column)
        let gridActionVC = GridActionViewController(
            gridViewModel: gridViewModel,
            renderer: gameRenderer,
            gridDataProvider: gameManager
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
