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
        setUpComponents(rows: 0, columns: 0)
    }

    init(rows: Int, columns: Int) {
        super.init()
        setUpComponents(rows: rows, columns: columns)
    }

    private func setUpComponents(rows: Int, columns: Int) {
        let gridComponent: GridComponent = GridComponent(rows: rows, columns: columns)
        addComponent(gridComponent)
    }
}
