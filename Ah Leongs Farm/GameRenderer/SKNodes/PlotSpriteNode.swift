//
//  PlotSpriteNode.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 2/4/25.
//

import SpriteKit

final class PlotSpriteNode: SpriteNode {
    private(set) weak var plot: Plot?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handler?.handleInteraction(node: self)
    }

    func setPlot(_ plot: Plot) {
        self.plot = plot
    }
}
