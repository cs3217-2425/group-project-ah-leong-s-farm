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

    func setTouchHandler(for node: AppleSpriteNode) {
        // Not yet implemented
    }

    func setTouchHandler(for node: BokChoySpriteNode) {
        // Not yet implemented
    }

    func setTouchHandler(for node: PotatoSpriteNode) {
        // Not yet implemented
    }
}
