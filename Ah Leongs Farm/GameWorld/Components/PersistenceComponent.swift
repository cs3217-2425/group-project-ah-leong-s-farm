//
//  PersistenceComponent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 1/4/25.
//

import GameplayKit

class PersistenceComponent: ComponentAdapter {
    let persistenceId: UUID
    let persistenceVisitor: GamePersistenceObject

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init(persistenceId: UUID, visitor: GamePersistenceObject) {
        self.persistenceId = persistenceId
        self.persistenceVisitor = visitor
        super.init()
    }
}
