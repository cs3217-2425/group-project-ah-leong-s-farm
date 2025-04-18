//
//  AppleSeed.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 13/4/25.
//

import Foundation

class AppleSeed: EntityAdapter, Seed {
    override init() {
        super.init()
        setUpComponents()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    private func setUpComponents() {
        let seedComponent = SeedComponent()
        attachComponent(seedComponent)
    }

    func toCrop() -> Crop {
        Apple()
    }

    func createNode(manager: SpriteRenderManager, renderer: GameRenderer) {
        manager.createNodeForEntity(appleSeed: self, in: renderer)
    }

    func transformNode(_ node: any IRenderNode, manager: SpriteRenderManager, renderer: GameRenderer) {
        manager.transformNodeForEntity(node, appleSeed: self, in: renderer)
    }
}
