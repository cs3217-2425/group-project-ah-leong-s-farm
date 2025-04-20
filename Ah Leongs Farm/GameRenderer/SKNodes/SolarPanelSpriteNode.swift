//
//  CropSpriteNode 2.swift
//  Ah Leongs Farm
//
//  Created by proglab on 15/4/25.
//

import SpriteKit

class SolarPanelSpriteNode: SpriteNode {
    private(set) weak var handler: SolarPanelSpriteNodeTouchHandler?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handler?.handleTouch(node: self)
    }

    func setHandler(_ handler: SolarPanelSpriteNodeTouchHandler) {
        self.handler = handler
    }

    override func visitTouchHandlerRegistry(registry: any TouchHandlerRegistry) {
        registry.setTouchHandler(for: self)
    }
}

protocol SolarPanelSpriteNodeTouchHandler: AnyObject {
    func handleTouch(node: SolarPanelSpriteNode)
}
