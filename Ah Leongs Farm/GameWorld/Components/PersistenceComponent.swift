//
//  PersistenceComponent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 1/4/25.
//

import GameplayKit

class PersistenceComponent: ComponentAdapter {
    let persistenceId: UUID
    let persistenceObject: GamePersistenceObject

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init(persistenceObject: GamePersistenceObject, persistenceId: UUID) {
        self.persistenceId = persistenceId
        self.persistenceObject = persistenceObject
        super.init()
    }

    // Can be used to initialize a PersistenceComponent whose persistenceID is not utilised
    convenience init(persistenceObject: GamePersistenceObject) {
        self.init(persistenceObject: persistenceObject, persistenceId: UUID())
    }
}
