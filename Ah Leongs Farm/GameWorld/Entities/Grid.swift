//
//  Grid.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/3/25.
//

import GameplayKit

class Grid: GKEntity {

    let rows: Int
    let columns: Int

    private(set) var plots: [[Plot]] = []

    required init?(coder: NSCoder) {
        rows = 0
        columns = 0
        super.init(coder: coder)
        addComponent(SpriteComponent(node: SKTileMapNode(coder: coder)))
    }

    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        super.init()
    }
}
