//
//  PlotSpriteNode.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 2/4/25.
//

import SpriteKit

final class PlotSpriteNode: SpriteNode {
    private(set) weak var handler: PlotSpriteNodeTouchHandler?
    private(set) weak var plot: Plot?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handler?.handleTouch(node: self)
    }

    func setPlot(_ plot: Plot) {
        self.plot = plot
    }

    func setHandler(_ handler: PlotSpriteNodeTouchHandler) {
        self.handler = handler
    }

    override func visitTouchHandlerRegistry(registry: any TouchHandlerRegistry) {
        registry.setTouchHandler(for: self)
    }
}

protocol PlotSpriteNodeTouchHandler: AnyObject {
    func handleTouch(node: PlotSpriteNode)
}
