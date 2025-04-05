//
//  ViewController+CropSpriteNodeTouchHandler.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 4/4/25.
//

extension ViewController: CropSpriteNodeTouchHandler {
    func handleTouch(node: CropSpriteNode) {
        guard let (row, column) = gameRenderer.getRowAndColumn(fromPosition: node.position) else {
            return
        }

        guard let plotViewModel = gameManager.getPlotViewModel(row: row, column: column) else {
            return
        }

        let plotActionVC = PlotActionViewController(
            plotViewModel: plotViewModel,
            eventQueue: gameManager.gameWorld,
            provider: gameManager
        )
        present(plotActionVC, animated: true)
    }
}
