//
//  Potato.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 30/3/25.
//

import Foundation
import GameplayKit

class Potato: GKEntity, Crop {
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
        addComponent(cropComponent)

        let healthComponent = HealthComponent()
        addComponent(healthComponent)
    }

    static func createSeed() -> GKEntity {
        let potato = Potato()
        potato.addComponent(SeedComponent())
        return potato
    }

    static func createHarvested() -> GKEntity {
        let potato = Potato()
        potato.addComponent(HarvestedComponent())
        return potato
    }

    func visitSpriteRenderManager(manager: SpriteRenderManager, renderer: GameRenderer) {
        manager.createNodeForEntity(potato: self, in: renderer)
    }
}
