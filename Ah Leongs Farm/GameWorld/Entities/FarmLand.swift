//
//  Grid.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/3/25.
//

import Foundation

class FarmLand: EntityAdapter {
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init(rows: Int, columns: Int) {
        super.init()
        setUpComponents(rows: rows, columns: columns)
    }

    private func setUpComponents(rows: Int, columns: Int) {
        let gridComponent = GridComponent(rows: rows, columns: columns)
        attachComponent(gridComponent)
    }
}

extension FarmLand: GamePersistenceObject {
    func save(manager: PersistenceManager, persistenceId: UUID) -> Bool {
        manager.save(farmLand: self, persistenceId: persistenceId)
    }

    func delete(manager: PersistenceManager, persistenceId: UUID) -> Bool {
        manager.delete(farmLand: self, persistenceId: persistenceId)
    }
}
