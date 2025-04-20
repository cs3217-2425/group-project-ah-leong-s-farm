//
//  BokChoySeedPersistenceEntity+SeedDeserializable.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 19/4/25.
//

import Foundation

extension BokChoySeedPersistenceEntity: SeedDeserializable {
    func deserialize() -> any Seed {
        guard let persistenceId = id else {
            let newPersistenceId = UUID()
            id = newPersistenceId
            return BokChoySeed(persistenceId: newPersistenceId)
        }

        return BokChoySeed(persistenceId: persistenceId)
    }
}
