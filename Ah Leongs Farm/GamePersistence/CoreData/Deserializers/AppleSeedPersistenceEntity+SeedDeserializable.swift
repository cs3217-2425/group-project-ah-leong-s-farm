//
//  AppleSeedPersistenceEntity+SeedDeserializable.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 19/4/25.
//

import Foundation

extension AppleSeedPersistenceEntity: SeedDeserializable {
    func deserialize() -> Seed {
        guard let persistenceId = id else {
            let newPersistenceId = UUID()
            id = newPersistenceId
            return AppleSeed(persistenceId: newPersistenceId)
        }

        return AppleSeed(persistenceId: persistenceId)
    }
}
