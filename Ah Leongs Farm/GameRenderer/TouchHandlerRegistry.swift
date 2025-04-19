//
//  TouchHandlerRegistry.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 30/3/25.
//

protocol TouchHandlerRegistry {
    func setTouchHandler(for node: PlotSpriteNode)

    func setTouchHandler(for node: CropSpriteNode)

    func setTouchHandler(for node: SolarPanelSpriteNode)
}

extension TouchHandlerRegistry {
    func acceptIntoTouchHandlerRegistry(node: IRenderNode) {
        node.visitTouchHandlerRegistry(registry: self)
    }
}
