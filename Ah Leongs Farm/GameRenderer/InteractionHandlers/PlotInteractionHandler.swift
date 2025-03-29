//
//  PlotInteractionHandler.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 29/3/25.
//

import Foundation

protocol PlotInteractionHandler: AnyObject {
    func showPlotActions(for plotNode: PlotSpriteNode)
}
