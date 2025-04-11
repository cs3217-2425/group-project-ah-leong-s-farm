//
//  Apple.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 30/3/25.
//

import Foundation

class Apple: EntityAdapter, Crop {
    override init() {
        super.init()
        setUpComponents()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    private func setUpComponents() {
        let cropComponent = CropComponent(cropType: .apple)
        attachComponent(cropComponent)

        let healthComponent = HealthComponent()
        attachComponent(healthComponent)

        let spriteComponent = SpriteComponent(visitor: self)
        attachComponent(spriteComponent)
    }

    static func createSeed() -> Entity {
        let apple = Apple()
        apple.attachComponent(SeedComponent())
        return apple
    }

    static func createHarvested() -> Entity {
        let apple = Apple()
        apple.attachComponent(HarvestedComponent())
        return apple
    }
}

extension Apple: SpriteRenderManagerVisitor {
    func visitSpriteRenderManager(manager: SpriteRenderManager, renderer: GameRenderer) {
        manager.createNodeForEntity(apple: self, in: renderer)
    }
}
