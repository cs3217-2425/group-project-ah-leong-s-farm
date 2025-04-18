//
//  BokChoy.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 25/3/25.
//

import Foundation

class BokChoy: EntityAdapter, Crop {
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
    }

    func visit(manager: SpriteRenderManager, renderer: GameRenderer) {
        manager.createNodeForEntity(crop: self, in: renderer)
    }

}
