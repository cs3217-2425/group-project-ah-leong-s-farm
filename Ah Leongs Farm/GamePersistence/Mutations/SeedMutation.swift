//
//  SeedMutation.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 19/4/25.
//

import Foundation

protocol SeedMutation<T> {
    associatedtype T: Seed

    func upsertSeed(sessionId: UUID, id: UUID, seed: T) -> Bool

    func deleteSeed(id: UUID, seed: T) -> Bool
}
