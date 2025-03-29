//
//  ViewController+PlotInteractionHandler.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 29/3/25.
//

import UIKit

extension ViewController: PlotInteractionHandler {
    func showPlotActions(for plotNode: PlotSpriteNode) {
        let plotActionVC = PlotActionViewController(plotNode: plotNode)
        present(plotActionVC, animated: true)
    }
}
