//
//  AppleSeed.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 13/4/25.
//

import Foundation

class AppleSeed: EntityAdapter, Seed, GamePersistenceObject {

    init(persistenceId: UUID) {
        super.init()
        setUpComponents(persistenceId: persistenceId)
    }

    override convenience init() {
        self.init(persistenceId: UUID())
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    private func setUpComponents(persistenceId: UUID) {
        let seedComponent = SeedComponent()
        attachComponent(seedComponent)

        let persistenceComponent = PersistenceComponent(
            persistenceObject: self,
            persistenceId: persistenceId
        )
        attachComponent(persistenceComponent)
    }

    func toCrop() -> Crop {
        Apple()
    }

    func visitSpriteRenderManager(manager: SpriteRenderManager, renderer: GameRenderer) {
        manager.createNodeForEntity(seed: self, in: renderer)
    }

    func save(manager: PersistenceManager, persistenceId: UUID) -> Bool {
        manager.save(appleSeed: self, persistenceId: persistenceId)
    }

    func delete(manager: PersistenceManager, persistenceId: UUID) -> Bool {
        manager.delete(appleSeed: self, persistenceId: persistenceId)
    }
}
