//
//  TouchHandlerRegistry.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 30/3/25.
//

protocol TouchHandlerRegistry {
    func setTouchHandler(for node: PlotSpriteNode)

    func setTouchHandler(for node: AppleSpriteNode)

    func setTouchHandler(for node: BokChoySpriteNode)

    func setTouchHandler(for node: PotatoSpriteNode)
}

extension TouchHandlerRegistry {
    func acceptIntoTouchHandlerRegistry(node: IRenderNode) {
        node.visitTouchHandlerRegistry(registry: self)
    }
}
