//
//  Potato.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 30/3/25.
//

import Foundation

class Potato: EntityAdapter, Crop {
    var seedItemType: ItemType = .potatoSeed
    var harvestedItemType: ItemType = .potatoHarvested

    override init() {
        super.init()
        setUpComponents()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    private func setUpComponents() {
        let cropComponent = CropComponent(cropType: .potato)
        attachComponent(cropComponent)

        let healthComponent = HealthComponent()
        attachComponent(healthComponent)

        let spriteComponent = SpriteComponent(visitor: self)
        attachComponent(spriteComponent)
    }

    static func createSeed() -> Entity {
        let potato = Potato()
        potato.attachComponent(SeedComponent())
        return potato
    }

    static func createHarvested() -> Entity {
        let potato = Potato()
        potato.attachComponent(HarvestedComponent())
        return potato
    }
}

extension Potato: SpriteRenderManagerVisitor {
    func visitSpriteRenderManager(manager: SpriteRenderManager, renderer: GameRenderer) {
        manager.createNodeForEntity(potato: self, in: renderer)
    }
}
