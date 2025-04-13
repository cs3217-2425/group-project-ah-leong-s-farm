//
//  PersistenceVisitor.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 1/4/25.
//

import Foundation

protocol GamePersistenceObject {
    func save(manager: PersistenceManager, persistenceId: UUID) -> Bool

    func delete(manager: PersistenceManager, persistenceId: UUID) -> Bool
}
