//
//  SpriteRenderSystem.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/3/25.
//

import GameplayKit

class TileMapSystem: GKComponentSystem<TileMapComponent> {

    private unowned var scene: SKScene

    init(scene: SKScene) {
        self.scene = scene
        super.init(componentClass: TileMapComponent.self)
    }

    override func addComponent(_ component: TileMapComponent) {
        super.addComponent(component)
        scene.addChild(component.tileMapNode)
    }

    override func removeComponent(_ component: TileMapComponent) {
        component.tileMapNode.removeFromParent()
        super.removeComponent(component)
    }

}
