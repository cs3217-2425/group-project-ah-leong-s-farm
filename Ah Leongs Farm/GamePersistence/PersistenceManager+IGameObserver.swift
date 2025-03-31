//
//  PersistenceManager+IGameObserver.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 1/4/25.
//

import GameplayKit

extension PersistenceManager: IGameObserver {
    func observe(entities: Set<GKEntity>) {
        for entity in entities {
            guard let persistenceComponent = entity.component(ofType: PersistenceComponent.self) else {
                continue
            }

            accept(visitor: persistenceComponent.persistenceVisitor)
        }
    }
}

