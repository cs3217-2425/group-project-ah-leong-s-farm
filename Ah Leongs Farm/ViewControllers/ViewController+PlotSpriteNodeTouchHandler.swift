//
//  ViewController+PlotSpriteNodeTouchHandler.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 2/4/25.
//

extension ViewController: PlotSpriteNodeTouchHandler {
    func handleTouch(node: PlotSpriteNode) {
        guard let (row, column) = gameRenderer.getRowAndColumn(fromPosition: node.position) else {
            return
        }

        guard let plotViewModel = gameManager.getPlotViewModel(row: row, column: column) else {
            return
        }

        let plotActionVC = PlotActionViewController(
            plotViewModel: plotViewModel,
            spriteNode: node,
            inventoryDataProvider: gameManager,
            plotDataProvider: gameManager
        )

        present(plotActionVC, animated: true)
    }
}
