//
//  Grid.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/3/25.
//

import GameplayKit

class FarmLand: GKEntity {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(rows: Int, columns: Int) {
        super.init()
        setUpComponents(rows: rows, columns: columns)
    }

    private func setUpComponents(rows: Int, columns: Int) {
        let gridComponent = GridComponent(rows: rows, columns: columns)
        let persistenceComponent = PersistenceComponent(visitor: self)
        addComponent(gridComponent)
        addComponent(persistenceComponent)
    }
}

extension FarmLand: PersistenceVisitor {
    func visitPersistenceManager(manager: PersistenceManager) {
        manager.save(farmLand: self)
    }
}
