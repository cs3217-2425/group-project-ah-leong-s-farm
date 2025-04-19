//
//  AbstractSeedPersistenceManager.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 19/4/25.
//

import Foundation

protocol AbstractSeedPersistenceManager {
    var sessionId: UUID { get }
    var seedQuery: (any SeedQuery)? { get }
    var appleSeedMutation: (any SeedMutation<AppleSeed>)? { get }
    var bokChoySeedMutation: (any SeedMutation<BokChoySeed>)? { get }
    var potatoSeedMutation: (any SeedMutation<PotatoSeed>)? { get }
}

extension AbstractSeedPersistenceManager {
    func loadSeeds() -> [any Seed] {
        guard let seedQuery = seedQuery else {
            return []
        }

        return seedQuery.fetch(sessionId: sessionId)
    }

    func save(appleSeed: AppleSeed, persistenceId: UUID) -> Bool {
        guard let appleSeedMutation = appleSeedMutation else {
            return false
        }

        return appleSeedMutation.upsertSeed(
            sessionId: sessionId,
            id: persistenceId,
            seed: appleSeed
        )
    }

    func delete(appleSeed: AppleSeed, persistenceId: UUID) -> Bool {
        guard let appleSeedMutation = appleSeedMutation else {
            return false
        }

        return appleSeedMutation.deleteSeed(id: persistenceId, seed: appleSeed)
    }

    func save(bokChoySeed: BokChoySeed, persistenceId: UUID) -> Bool {
        guard let bokChoySeedMutation = bokChoySeedMutation else {
            return false
        }

        return bokChoySeedMutation.upsertSeed(
            sessionId: sessionId,
            id: persistenceId,
            seed: bokChoySeed
        )
    }

    func delete(bokChoySeed: BokChoySeed, persistenceId: UUID) -> Bool {
        guard let bokChoySeedMutation = bokChoySeedMutation else {
            return false
        }

        return bokChoySeedMutation.deleteSeed(id: persistenceId, seed: bokChoySeed)
    }

    func save(potatoSeed: PotatoSeed, persistenceId: UUID) -> Bool {
        guard let potatoSeedMutation = potatoSeedMutation else {
            return false
        }

        return potatoSeedMutation.upsertSeed(
            sessionId: sessionId,
            id: persistenceId,
            seed: potatoSeed
        )
    }

    func delete(potatoSeed: PotatoSeed, persistenceId: UUID) -> Bool {
        guard let potatoSeedMutation = potatoSeedMutation else {
            return false
        }

        return potatoSeedMutation.deleteSeed(id: persistenceId, seed: potatoSeed)
    }
}
