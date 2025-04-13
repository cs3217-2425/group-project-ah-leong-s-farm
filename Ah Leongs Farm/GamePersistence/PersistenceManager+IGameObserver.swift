//
//  PersistenceManager+IGameObserver.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 1/4/25.
//

import GameplayKit

extension PersistenceManager: IGameObserver {
    func observe(entities: [any Entity]) {
        for entity in entities {
            guard let persistenceComponent = entity.getComponentByType(
                ofType: PersistenceComponent.self) else {
                continue
            }

            let persistenceVisitor = persistenceComponent.persistenceVisitor
            accept(visitor: persistenceVisitor)
        }
    }
}
