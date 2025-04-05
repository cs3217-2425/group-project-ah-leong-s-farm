//
//  ViewController+TouchHandlerRegistry.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 2/4/25.
//

extension ViewController: TouchHandlerRegistry {

    func setTouchHandler(for node: PlotSpriteNode) {
        if node.handler !== self {
            node.setHandler(self)
        }
    }

    func setTouchHandler(for node: CropSpriteNode) {
        if node.handler !== self {
            node.setHandler(self)
        }
    }
}
