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
        let persistenceComponent = PersistenceComponent(visitor: self)
        attachComponent(gridComponent)
        attachComponent(persistenceComponent)
    }
}

extension FarmLand: PersistenceVisitor {
    func visitPersistenceManager(manager: PersistenceManager) {
        manager.save(farmLand: self)
    }
}
