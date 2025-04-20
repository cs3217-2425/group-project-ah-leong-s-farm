//
//  ViewController+SolarPanelSpriteNodeTouchHandler.swift
//  Ah Leongs Farm
//
//  Created by proglab on 16/4/25.
//

extension ViewController: SolarPanelSpriteNodeTouchHandler {
    func handleTouch(node: SolarPanelSpriteNode) {
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
