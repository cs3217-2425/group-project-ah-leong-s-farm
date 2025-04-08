//
//  BokChoy.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 25/3/25.
//

import Foundation

class BokChoy: EntityAdapter, Crop {
    var seedItemType: ItemType = .bokChoySeed
    var harvestedItemType: ItemType = .bokChoyHarvested

    override init() {
        super.init()
        setUpComponents()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    private func setUpComponents() {
        let cropComponent = CropComponent(cropType: .bokChoy)
        attachComponent(cropComponent)

        let healthComponent = HealthComponent()
        attachComponent(healthComponent)

        let spriteComponent = SpriteComponent(visitor: self)
        attachComponent(spriteComponent)
    }

    static func createSeed() -> Entity {
        let bokChoy = BokChoy()
        bokChoy.attachComponent(SeedComponent())
        return bokChoy
    }

    static func createHarvested() -> Entity {
        let bokChoy = BokChoy()
        bokChoy.attachComponent(HarvestedComponent())
        return bokChoy
    }
}

extension BokChoy: SpriteRenderManagerVisitor {
    func visitSpriteRenderManager(manager: SpriteRenderManager, renderer: GameRenderer) {
        manager.createNodeForEntity(bokChoy: self, in: renderer)
    }
}
