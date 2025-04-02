//
//  ViewController+InteractionHandler.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 30/3/25.
//

import UIKit

extension ViewController: GridInteractionHandler {
    func handleGridInteraction(row: Int, column: Int) {
        let gridActionVC = GridActionViewController(row: row, column: column, renderer: gameRenderer)
        gameRenderer.lightUpTile(at: row, column: column)
        present(gridActionVC, animated: true)
    }
}
