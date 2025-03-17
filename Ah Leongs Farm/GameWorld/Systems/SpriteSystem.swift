//
//  SpriteSystem.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 16/3/25.
//
import GameplayKit

class SpriteSystem: GKComponentSystem<SpriteComponent> {
    private unowned var scene: SKScene

    init(scene: SKScene) {
        self.scene = scene
        super.init(componentClass: TileMapComponent.self)
    }

    override func addComponent(_ component: SpriteComponent) {
        super.addComponent(component)
        scene.addChild(component.spriteNode)
    }

    override func removeComponent(_ component: SpriteComponent) {
        component.spriteNode.removeFromParent()
        super.removeComponent(component)
    }
}
