//
//  GamePersistenceMetaData.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/4/25.
//

import Foundation

class GamePersistenceMetaData {
    let persistenceId: UUID
    let persistenceObject: GamePersistenceObject

    init(persistenceId: UUID, persistenceObject: GamePersistenceObject) {
        self.persistenceId = persistenceId
        self.persistenceObject = persistenceObject
    }
}
