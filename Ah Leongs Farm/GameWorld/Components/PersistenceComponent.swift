//
//  PersistenceComponent.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 1/4/25.
//

import GameplayKit

class PersistenceComponent: ComponentAdapter {
    let persistenceVisitor: PersistenceVisitor

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init(visitor: PersistenceVisitor) {
        self.persistenceVisitor = visitor
        super.init()
    }
}
